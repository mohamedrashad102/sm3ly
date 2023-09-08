import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm3ly/constant.dart';

import 'font.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final bool enabled;
  final bool obscureText;
  final int? maxLength;
  final TextStyle? textStyle;
  final String? Function(String?)? validator;
  final String? suffixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.enabled = true,
    this.textStyle,
    this.textAlign = TextAlign.left,
    this.suffixText,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        textAlign: textAlign,
        textDirection: textAlign == TextAlign.left? TextDirection.ltr: TextDirection.rtl,
        obscureText: obscureText,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        style: textStyle,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelStyle: MyFonts.englishFont(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
          labelText: labelText,
          suffixText: suffixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: MyColors.gradient1,
            ),
          ),
        ),
      ),
    );
  }
}
