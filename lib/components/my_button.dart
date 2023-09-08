import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';
class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onPressed, required this.text});
  final void Function() onPressed;
  final String text;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.textButton,
          minimumSize: const Size(250, 50),
        ),
        onPressed: onPressed,
        child: CustomText(
          text: text,
          fontSize: 20,
        ));
  }
}
