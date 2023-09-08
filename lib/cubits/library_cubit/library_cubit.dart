import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/components/my_button.dart';
import 'package:sm3ly/cubits/library_cubit/library_states.dart';
import 'package:sm3ly/cubits/user_cubit/user_cubit.dart';
import 'package:sm3ly/helpers/has_network.dart';
import 'package:sm3ly/models/word_model.dart';
import 'package:sm3ly/service/firestore_helper.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';
import 'package:uuid/uuid.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/delete_button.dart';
import '../../models/class_model.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitState());
  static LibraryCubit get(context) => BlocProvider.of(context);

  FlutterTts flutterTts = FlutterTts();

  final TextEditingController classTitleController = TextEditingController();
  final TextEditingController arabicWordController = TextEditingController();
  final TextEditingController englishWordController = TextEditingController();
  late List<TextEditingController> wordsController = [];
  late int currentClassIndex;
  late int totalWordsOfClass;
  late int totalWordsOfChallenge;

  List<ClassModel> classesData = [];
  List<List<WordModel>> wordsData = [];
  List<WordModel> testWordsData = [];

  // for classes
  Future<void> createNewClass() async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    emit(LibraryAddNewClassState());
  }

  Future<void> editClass(int index) async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    classTitleController.text = classesData[index].title;
    emit(LibraryEditClassState(index));
  }

  Future<void> deleteClass(int index) async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    emit(LibraryDeleteClassState(index));
  }

  void showCreateNewClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.8),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.textButton,
                maximumSize: const Size(250, 50),
              ),
              onPressed: () async {
                final String title = classTitleController.text.trim();
                if (title.isNotEmpty) {
                  Navigator.of(context).pop();
                  final String id = const Uuid().v1();
                  ClassModel newClass = ClassModel(
                    id: id,
                    title: title,
                    createdAt: DateTime.now(),
                  );
                  classesData.add(newClass);
                  wordsData.add([]);
                  classTitleController.clear();
                  UserCubit.get(context).fetchUserData();
                  emit(LibrarySuccessState());
                  await FirestoreHelper.createNewClass(newClass);
                  await SharedPreferencesHelper.setClassesData(classesData);
                  await SharedPreferencesHelper.setWordsData(wordsData);
                } else {
                  emit(
                    LibraryErrorState('you should enter title'),
                  );
                }
              },
              child: const CustomText(
                text: 'Add',
              ),
            ),
          )
        ],
        contentPadding: const EdgeInsets.all(5),
        title: const Center(
          child: CustomText(
            text: 'Add your class title',
            fontSize: 20,
            color: MyColors.textButton,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: classTitleController,
              labelText: "Class Title",
              maxLength: 20,
            ),
          ],
        ),
      ),
    );
  }

  void showEditClassDialog(BuildContext context, int classIndex) {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.8),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.textButton,
                maximumSize: const Size(250, 50),
              ),
              onPressed: () async {
                String title = classTitleController.text.trim();
                if (title.isNotEmpty) {
                  Navigator.of(context).pop();
                  var currentClass = classesData[classIndex];
                  ClassModel newClass = ClassModel(
                    id: currentClass.id,
                    title: title,
                    createdAt: currentClass.createdAt,
                  );
                  classesData[classIndex] = newClass;
                  classTitleController.clear();
                  emit(LibrarySuccessState());
                  await FirestoreHelper.editClassTitle(currentClass, newClass);
                  await SharedPreferencesHelper.setClassesData(classesData);
                } else {
                  emit(LibraryErrorState('you should enter title'));
                }
              },
              child: const CustomText(
                text: 'Save',
              ),
            ),
          )
        ],
        contentPadding: const EdgeInsets.all(5),
        title: const Center(
          child: CustomText(
            text: 'Edit class title',
            fontSize: 20,
            color: MyColors.textButton,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: classTitleController,
              labelText: "New title",
              maxLength: 20,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the title';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteClassDialog(BuildContext context, int classIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DeleteButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel"),
                DeleteButton(
                  onPressed: () async {
                    var currentClass = classesData[classIndex];
                    classesData.removeAt(classIndex);
                    wordsData.removeAt(classIndex);
                    Navigator.of(context).pop();
                    UserCubit.get(context).fetchUserData();
                    emit(LibrarySuccessState());
                    await FirestoreHelper.deleteClass(currentClass);
                    await SharedPreferencesHelper.setClassesData(classesData);
                    await SharedPreferencesHelper.setWordsData(wordsData);
                  },
                  text: "Delete",
                  color: Colors.red,
                )
              ],
            )
          ],
          contentPadding: const EdgeInsets.all(20),
          content: const CustomText(
            text: 'Do you want to delete this class',
            color: Colors.black,
          )),
    );
  }

  // only when user open library
  Future<void> _fetchClassesData() async {
    if (await hasNetwork()) {
      emit(LibraryClassLoadingState());
      classesData = await FirestoreHelper.fetchClassesData();
      emit(LibrarySuccessState());
    }
  }

  // for words
  Future<void> openWordsScreen(int classIndex) async {
    currentClassIndex = classIndex;
    emit(LibrarySuccessOpenWordsScreenState());
  }

  Future<void> createNewWord(int classIndex) async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    emit(LibraryAddNewWordState(classIndex));
  }

  Future<void> editWord(int classIndex, int wordIndex) async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    arabicWordController.text = wordsData[classIndex][wordIndex].arabicWord;
    englishWordController.text = wordsData[classIndex][wordIndex].englishWord;
    emit(LibraryEditWordState(classIndex, wordIndex));
  }

  Future<void> deleteWord(int classIndex, int wordIndex) async {
    if (!await hasNetwork()) {
      emit(LibraryErrorState('No Internet Connection'));
      return;
    }
    emit(LibraryDeleteWordState(classIndex, wordIndex));
  }

  void wordDialog(BuildContext context,
      {required String titleText,
      required String buttonText,
      required void Function()? onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.textButton,
                maximumSize: const Size(250, 50),
              ),
              onPressed: onPressed,
              child: CustomText(
                text: buttonText,
              ),
            ),
          )
        ],
        contentPadding: const EdgeInsets.all(5),
        title: Center(
          child: CustomText(
            text: titleText,
            fontSize: 20,
            color: MyColors.textButton,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: arabicWordController,
              labelText: "Word Name",
              textAlign: TextAlign.right,
              maxLength: 15,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF ]')),
              ],
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              controller: englishWordController,
              labelText: "Its synonym",
              maxLength: 15,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showCreateNewWordDialog(BuildContext context, int classIndex) {
    wordDialog(
      context,
      titleText: "Add your word",
      buttonText: "Add",
      onPressed: () async {
        if (arabicWordController.text.trim().isNotEmpty &&
            englishWordController.text.trim().isNotEmpty) {
          final String id = const Uuid().v1();
          var currentClass = classesData[classIndex];
          var newWord = WordModel(
            arabicWord: arabicWordController.text.trim(),
            englishWord: englishWordController.text.trim(),
            id: id,
            createdAt: DateTime.now(),
          );
          wordsData[classIndex].add(newWord);
          arabicWordController.clear();
          englishWordController.clear();
          Navigator.of(context).pop();
          UserCubit.get(context).fetchUserData();
          emit(LibrarySuccessState());
          await FirestoreHelper.createNewWord(currentClass, newWord);
          await SharedPreferencesHelper.setWordsData(wordsData);
        } else {
          emit(LibraryErrorState('you should enter word and its synonym'));
        }
      },
    );
  }

  void showEditWordDialog(BuildContext context, int classIndex, int wordIndex) {
    wordDialog(
      context,
      titleText: "Edit your word",
      buttonText: "Edit",
      onPressed: () async {
        if (arabicWordController.text.trim().isNotEmpty &&
            englishWordController.text.trim().isNotEmpty) {
          var currentClass = classesData[classIndex];
          var currentWord = wordsData[classIndex][wordIndex];
          var newWord = WordModel(
            arabicWord: arabicWordController.text.trim(),
            englishWord: englishWordController.text.trim(),
            id: currentWord.id,
            createdAt: currentWord.createdAt,
          );
          wordsData[classIndex][wordIndex] = newWord;
          arabicWordController.clear();
          englishWordController.clear();
          Navigator.of(context).pop();
          emit(LibrarySuccessState());
          await FirestoreHelper.editWord(
              currentClass: currentClass, newWord: newWord);
          await SharedPreferencesHelper.setWordsData(wordsData);
        } else {
          emit(LibraryErrorState('you should enter word and its synonym'));
        }
      },
    );
  }

  void showDeleteWordDialog(
      BuildContext context, int classIndex, int wordIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DeleteButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel"),
                DeleteButton(
                  onPressed: () async {
                    var currentClass = classesData[classIndex];
                    var currentWord = wordsData[classIndex][wordIndex];
                    wordsData[classIndex].removeAt(wordIndex);
                    Navigator.of(context).pop();
                    UserCubit.get(context).fetchUserData();
                    emit(LibrarySuccessState());
                    await FirestoreHelper.deleteWord(
                      currentClass: currentClass,
                      currentWord: currentWord,
                    );
                    await SharedPreferencesHelper.setWordsData(wordsData);
                  },
                  text: "Delete",
                  color: Colors.red,
                )
              ],
            )
          ],
          contentPadding: const EdgeInsets.all(20),
          content: const CustomText(
            text: "Do you want to delete this Word?",
            color: Colors.black,
          )),
    );
  }

  // only when user open library
  Future<void> _fetchWordsData() async {
    if (await hasNetwork()) {
      emit(LibraryWordLoadingState());
      wordsData.clear();
      for (var currentClass in classesData) {
        wordsData.add(await FirestoreHelper.fetchWordsData(currentClass));
      }
      emit(LibrarySuccessState());
    }
  }

  // for challenge
  void selectChallengeSystem(int classIndex) {
    try {
      var currentClass = wordsData[classIndex];
      currentClassIndex = classIndex;
      totalWordsOfClass = currentClass.length;
      totalWordsOfChallenge = totalWordsOfClass ~/ 2;
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(LibrarySelectChallengeSystem());
  }

  void startRandomWordsChallenge() {
    try {
      List<WordModel> currentWords = wordsData[currentClassIndex];
      currentWords.shuffle();
      testWordsData =
          List.generate(totalWordsOfChallenge, (index) => currentWords[index]);
      wordsController = List.generate(
          totalWordsOfChallenge, (index) => TextEditingController());
      emit(LibraryStartRandomWordsChallenge());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showSelectChallengeSystemDialog(BuildContext context) {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                  color: Colors.black,
                  fontSize: 15,
                  text: "Select the test System"),
              const SizedBox(
                width: 6,
              ),
              Image.asset("assets/images/check.png")
            ],
          ),
          actionsPadding: const EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            Center(
                child: MyButton(
                    onPressed: () {
                      try {
                        totalWordsOfChallenge = totalWordsOfClass;
                        startRandomWordsChallenge();
                      } catch (e) {
                        debugPrint('error: ${e.toString()}');
                      }
                    },
                    text: "All Words")),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                  child: MyButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        emit(LibraryErrorState('Coming soon'));
                        // emit(LibrarySelectRandomWordsChallenge());
                      },
                      text: "Random Words")),
            ),
            Center(
                child: MyButton(
                    onPressed: () {
                      emit(LibraryErrorState('Coming soon'));
                    },
                    text: "Specific Words"))
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showSelectRandomWordsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.8),
        title: CustomText(
            color: Colors.black,
            fontSize: 15,
            text: "Select the number of Words, total: $totalWordsOfClass"),
        actionsPadding: const EdgeInsets.all(20),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => incrementTotalWordsOfChallenge(),
                    child: const Icon(
                      Icons.add_circle_outlined,
                      color: MyColors.textButton,
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: MyColors.textButton),
                    ),
                    child: Center(
                      child: CustomText(
                        color: Colors.black,
                        text: '$totalWordsOfChallenge',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: decrementTotalWordsOfChallenge,
                    child: const Icon(
                      Icons.remove_circle_outlined,
                      color: MyColors.textButton,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(onPressed: startRandomWordsChallenge, text: "Select")
            ],
          ),
        ],
      ),
    );
  }

  void finishChallenge() {
    int result = 0;
    for (int i = 0; i < totalWordsOfChallenge; i++) {
      if (testWordsData[i].englishWord.trim().toLowerCase() ==
          wordsController[i].text.trim().toLowerCase()) {
        result++;
      }
    }
    emit(LibraryFinishChallengeState(result));
  }

  void tryChallengeAgain() {
    for (int i = 0; i < wordsController.length; i++) {
      wordsController[i].clear();
    }
    testWordsData.shuffle();
    emit(LibrarySuccessState());
  }

  void incrementTotalWordsOfChallenge() {
    if (totalWordsOfChallenge < totalWordsOfClass) {
      totalWordsOfChallenge++;
    }
    emit(LibrarySuccessState());
  }

  void decrementTotalWordsOfChallenge() {
    if (totalWordsOfChallenge > 1) {
      totalWordsOfChallenge--;
    }
    emit(LibrarySuccessState());
  }

  Future<void> fetchLibraryData() async {
    if (await hasNetwork()) {
      _fetchClassesData().then(
        (value) async {
          await _fetchWordsData();
          SharedPreferencesHelper.setClassesData(classesData);
          SharedPreferencesHelper.setWordsData(wordsData);
        },
      );
    } else {
      classesData = SharedPreferencesHelper.getClassesData();
      wordsData = SharedPreferencesHelper.getWordsData();
      emit(LibrarySuccessState());
    }
  }
}
