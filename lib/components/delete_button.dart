import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });
  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(50, 40),
      ),
      onPressed: onPressed,
      child: CustomText(
        text: text,
        
      ),
    );
  }
}
