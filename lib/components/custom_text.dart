import 'package:flutter/material.dart';

import 'font.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w500,
    this.isArabicFont = false, 
    this.textAlign = TextAlign.start,
  });

  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  final bool isArabicFont;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
    textAlign: textAlign,
        style: MyFonts.englishFont(
          fontWeight: fontWeight,
          size: fontSize,
          color: color,
        ));
  }
}
