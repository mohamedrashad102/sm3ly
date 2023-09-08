import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sm3ly/components/font.dart';
import 'package:sm3ly/constant.dart';

class CustomPageView {
  static PageViewModel buildPageView(
      {required String title,
      required String body,
      required String pathImage}) {
    return PageViewModel(
      title: title,
      body: body,
      image: Center(
          child: Image.asset(
        pathImage,
        height: 500,
        width: 500,
      )),
      decoration: PageDecoration(
        pageColor: Colors.white,
        titleTextStyle:
            MyFonts.englishFont(size: 25, color: MyColors.textButton),
        bodyTextStyle: MyFonts.englishFont(size: 13),
      ),
    );
  }
}
