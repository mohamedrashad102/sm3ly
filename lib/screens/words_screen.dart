import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/components/word_card.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/library_cubit/library_states.dart';
import 'package:sm3ly/helpers/show_snack_bar.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});
  static const String id = 'class words screen';

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

MenuController menuController = MenuController();

class _WordsScreenState extends State<WordsScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = LibraryCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.textButton,
        centerTitle: true,
        title: CustomText(
          text: cubit.classesData[cubit.currentClassIndex].title,
          fontSize: 23,
        ),
      ),
      body: BlocConsumer<LibraryCubit, LibraryState>(
        listener: (context, state) {
          if (state is LibraryErrorState) {
            showSnackBar(context, text: state.errorMessage, isError: true);
          } else if (state is LibraryAddNewWordState) {
            cubit.arabicWordController.clear();
            cubit.englishWordController.clear();
            cubit.showCreateNewWordDialog(context, state.classIndex);
          } else if (state is LibraryEditWordState) {
            cubit.showEditWordDialog(
                context, state.classIndex, state.wordIndex);
          } else if (state is LibraryDeleteWordState) {
            cubit.showDeleteWordDialog(
                context, state.classIndex, state.wordIndex);
          }
        },
        builder: (context, state) {
          if (state is LibraryWordLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyColors.textButton,
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cubit.wordsData[cubit.currentClassIndex].length + 1,
                itemBuilder: (BuildContext context, int wordIndex) =>
                    wordIndex == cubit.wordsData[cubit.currentClassIndex].length
                        ? const SizedBox(
                            height: 60,
                          )
                        : WordCard(
                            currentWord: cubit
                                .wordsData[cubit.currentClassIndex][wordIndex],
                            edit: () async => cubit.editWord(
                                cubit.currentClassIndex, wordIndex),
                            delete: () async => cubit.deleteWord(
                                cubit.currentClassIndex, wordIndex),
                            onPressed: () async {
                             await cubit.flutterTts.speak(cubit
                                .wordsData[cubit.currentClassIndex][wordIndex].englishWord);
                            },
                          ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async => cubit.createNewWord(cubit.currentClassIndex),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.textButton,
            shape: const CircleBorder(),
            minimumSize: const Size(55, 55)),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
