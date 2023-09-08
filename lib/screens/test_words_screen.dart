import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/components/custom_text_form_field.dart';
import 'package:sm3ly/components/font.dart';
import 'package:sm3ly/components/my_button.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/library_cubit/library_states.dart';

class TestWordsScreen extends StatelessWidget {
  TestWordsScreen({super.key});
  static const String id = 'test words screen';
  final GlobalKey<FormState> submitFormKey =
      GlobalKey<FormState>(debugLabel: 'submitFormKey');

  @override
  Widget build(BuildContext context) {
    var cubit = LibraryCubit.get(context);
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        if (state is LibraryWordLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.textButton,
            ),
          );
        }
        if (state is LibraryFinishChallengeState) {
          return Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              height: 60,
              child: Align(
                child: MyButton(
                  onPressed: () => cubit.tryChallengeAgain(),
                  text: "Try Again",
                ),
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: CustomText(
                text: "Result: ${state.result}/${cubit.totalWordsOfChallenge}",
                fontSize: 25,
              ),
              backgroundColor: MyColors.textButton,
            ),
            body: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: cubit.totalWordsOfChallenge,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  endIndent: 20,
                  indent: 20,
                  color: MyColors.appBar,
                  thickness: 1,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomTextFormField(
                    controller: cubit.wordsController[index],
                    labelText: cubit.testWordsData[index].arabicWord,
                    textStyle: MyFonts.englishFont(
                      color: cubit.testWordsData[index].englishWord
                                  .trim()
                                  .toLowerCase() ==
                              cubit.wordsController[index].text
                                  .trim()
                                  .toLowerCase()
                          ? Colors.blue
                          : Colors.red,
                      size: 20,
                    ),
                    suffixIcon: cubit.testWordsData[index].englishWord
                                .trim()
                                .toLowerCase() ==
                            cubit.wordsController[index].text
                                .trim()
                                .toLowerCase()
                        ? const Icon(
                            Icons.done,
                            color: Colors.blue,
                          )
                        : const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                    enabled: false,
                    suffixText: cubit.testWordsData[index].englishWord.trim(),
                  ),
                );
              },
            ),
          );
        }
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            height: 60,
            child: Align(
              child: MyButton(
                onPressed: () {
                  if (submitFormKey.currentState!.validate()) {
                    cubit.finishChallenge();
                  }
                },
                text: "Submit",
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const CustomText(
              text: "Test your words",
              fontSize: 25,
            ),
            backgroundColor: MyColors.textButton,
          ),
          body: Form(
            key: submitFormKey,
            child: GestureDetector(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: cubit.totalWordsOfChallenge,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    endIndent: 20,
                    indent: 20,
                    color: MyColors.appBar,
                    thickness: 1,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomTextFormField(
                      controller: cubit.wordsController[index],
                      labelText: cubit.testWordsData[index].arabicWord,
                      keyboardType: TextInputType.emailAddress,
                      textStyle: MyFonts.englishFont(
                        size: 20,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'you must enter the word';
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
