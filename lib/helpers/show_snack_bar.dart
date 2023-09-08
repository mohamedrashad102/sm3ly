import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';

void showSnackBar(
  BuildContext context, {
  required String text,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: CustomText(
          text: text,
        ),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ),
  );
}
