import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/class_card.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/library_cubit/library_states.dart';
import 'package:sm3ly/helpers/show_snack_bar.dart';
import 'package:sm3ly/models/class_model.dart';

import 'package:sm3ly/constant.dart';
import 'package:sm3ly/screens/words_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  static const String id = 'library screen';

  @override
  Widget build(BuildContext context) {
    var cubit = LibraryCubit.get(context);
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const CustomText(
          text: "Library",
          fontSize: 25,
        ),
        centerTitle: true,
        backgroundColor: MyColors.appBar,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => cubit.createNewClass(),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.textButton,
            shape: const CircleBorder(),
            minimumSize: const Size(55, 55)),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: BlocConsumer<LibraryCubit, LibraryState>(
        listener: (context, state) {
          if (state is LibraryErrorState) {
            showSnackBar(context, text: state.errorMessage, isError: true);
          } else if (state is LibraryAddNewClassState) {
            cubit.classTitleController.clear();
            cubit.showCreateNewClassDialog(context);
          } else if (state is LibraryEditClassState) {
            cubit.showEditClassDialog(context, state.index);
          } else if (state is LibraryDeleteClassState) {
            cubit.showDeleteClassDialog(context, state.index);
          } else if (state is LibrarySuccessOpenWordsScreenState) {
            Navigator.pushNamed(context, WordsScreen.id);
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
            padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, classIndex) => Align(
                      alignment: Alignment.centerRight,
                      child: classIndex == cubit.classesData.length
                          ? const SizedBox(
                              height: 40,
                            )
                          : ClassCard(
                              currentClass: ClassModel(
                                id: cubit.classesData[classIndex].id,
                                title: cubit.classesData[classIndex].title,
                                createdAt:
                                    cubit.classesData[classIndex].createdAt,
                              ),
                              index: classIndex.toString(),
                              delete: () async => cubit.deleteClass(classIndex),
                              edit: () async => cubit.editClass(classIndex),
                              onTap: () async =>
                                  cubit.openWordsScreen(classIndex),
                            ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: cubit.classesData.length + 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
