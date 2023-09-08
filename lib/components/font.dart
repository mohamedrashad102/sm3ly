import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFonts {
  static TextStyle englishFont({
    Color? color,
    double? size,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.kanit(
        textStyle: TextStyle(
      fontWeight: fontWeight,
      fontSize: size,
      color: color,
    ));
  }
}
