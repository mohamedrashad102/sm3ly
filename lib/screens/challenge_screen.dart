import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sm3ly/constant.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/library_cubit/library_states.dart';
import 'package:sm3ly/helpers/show_snack_bar.dart';
import 'package:sm3ly/screens/test_words_screen.dart';
import '../components/font.dart';
import '../components/test_item.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});
  static const String id = 'challenge screen';

  @override
  Widget build(BuildContext context) {
    var cubit = LibraryCubit.get(context);
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Challenge",
          style: MyFonts.englishFont(size: 25),
        ),
        backgroundColor: MyColors.appBar,
      ),
      body: BlocConsumer<LibraryCubit, LibraryState>(
        listener: (context, state) {
          if (state is LibrarySelectChallengeSystem) {
            cubit.showSelectChallengeSystemDialog(context);
          } else if (state is LibrarySelectRandomWordsChallenge) {
            cubit.showSelectRandomWordsDialog(context);
          } else if (state is LibraryStartRandomWordsChallenge) {
            Navigator.pop(context);
            if (cubit.totalWordsOfClass == 0) {
              showSnackBar(context,
                  text: 'Class has no words yet', isError: true);
            } else {
              Navigator.pushNamed(context, TestWordsScreen.id);
            }
          } else if (state is LibraryErrorState) {
            showSnackBar(context, text: state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          if (state is LibraryClassLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyColors.textButton,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
              ),
              itemCount: cubit.classesData.length,
              itemBuilder: (BuildContext context, int classIndex) {
                return GestureDetector(
                  onTap: () {
                    cubit.selectChallengeSystem(classIndex);
                  },
                  child: TestItem(
                    index: classIndex,
                    currentClass: cubit.classesData[classIndex],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
