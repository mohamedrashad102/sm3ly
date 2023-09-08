import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/models/class_model.dart';

class ClassCard extends StatefulWidget {
  const ClassCard({
    super.key,
    required this.currentClass,
    required this.index,
    required this.delete,
    required this.edit,
    required this.onTap,
  });

  final ClassModel currentClass;
  final String index;
  final void Function() delete;
  final void Function() edit;
  final void Function() onTap;

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          // menu and title
          Row(
            children: [
              // menu icon button
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: MyColors.textButton,
                  ),
                  height: 60,
                  margin: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      MenuAnchor(
                        controller: menuController,
                        menuChildren: [
                          MenuItemButton(
                            onPressed: widget.edit,
                            leadingIcon: const Icon(
                              Icons.edit_square,
                              color: MyColors.textButton,
                            ),
                            child: const CustomText(
                              text: "Edit",
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          const Divider(
                            color: MyColors.textButton,
                            thickness: 1,
                          ),
                          MenuItemButton(
                            onPressed: widget.delete,
                            leadingIcon: const Icon(
                              Icons.delete,
                              color: MyColors.textButton,
                            ),
                            child: const CustomText(
                              text: "Delete",
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          )
                        ],
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(
                            () => menuController.isOpen
                                ? menuController.close()
                                : menuController.open(),
                          ),
                        ),
                      ),
                      // class title
                      Expanded(
                        child: CustomText(
                          text: widget.currentClass.title,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 35),
            ],
          ),
          // class index
          Container(
            decoration: const BoxDecoration(
              color: MyColors.scaffold,
              shape: BoxShape.circle,
            ),
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                color: MyColors.textButton,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomText(
                  text: widget.index,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
