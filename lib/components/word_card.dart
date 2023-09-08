import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/models/word_model.dart';

class WordCard extends StatefulWidget {
  const WordCard({
    super.key,
    required this.delete,
    required this.edit,
    required this.currentWord,
    required this.onPressed,
  });

  final WordModel currentWord;
  final void Function()? delete;
  final void Function()? edit;
  final void Function()? onPressed;
  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 7,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuAnchor(
                  controller: menuController,
                  menuChildren: [
                    MenuItemButton(
                      leadingIcon: const Icon(
                        Icons.edit_square,
                        color: MyColors.textButton,
                      ),
                      onPressed: widget.edit,
                      child: const CustomText(
                        text: "Edit",
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                      color: MyColors.textButton,
                      thickness: 1,
                    ),
                    MenuItemButton(
                      leadingIcon: const Icon(
                        Icons.delete,
                        color: MyColors.textButton,
                      ),
                      onPressed: widget.delete,
                      child: const CustomText(
                        text: "Delete",
                        color: Colors.black,
                      ),
                    )
                  ],
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: MyColors.textButton,
                    ),
                    onPressed: () {
                      setState(() {
                        if (menuController.isOpen) {
                          menuController.close();
                        } else {
                          menuController.open();
                        }
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: widget.currentWord.arabicWord,
                  fontSize: 20,
                  color: Colors.black,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: widget.currentWord.englishWord,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: widget.onPressed,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: MyColors.textButton,
                ),
                color: MyColors.textButton,
              )
            ],
          ),
        ],
      ),
    );
  }
}
