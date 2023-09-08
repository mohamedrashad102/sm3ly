import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/models/class_model.dart';

class TestItem extends StatelessWidget {
  const TestItem({
    super.key,
    required this.index,
    required this.currentClass,
  });
  final int index;
  final ClassModel currentClass;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 60,
          decoration: const BoxDecoration(
            color: MyColors.textButton,
            // boxShadow: [
            //   BoxShadow(
            //       color: Color.fromARGB(255, 233, 233, 233),
            //       offset: Offset(3, 3)),
            // ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(99)),
          ),
          child: CustomText(
            text: "$index",
            fontSize: 20,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: MyColors.textButton,
            // boxShadow: const [
            //   BoxShadow(
            //       color: Color.fromARGB(255, 233, 233, 233),
            //       offset: Offset(3, 3)),
            // ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: CustomText(
              text: currentClass.title,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
