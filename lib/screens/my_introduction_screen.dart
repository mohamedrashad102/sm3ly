import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sm3ly/components/custom_page_view.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/screens/login_screen.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';

void onDone(context) {
  SharedPreferencesHelper.setIsFirstTime(false);
  Navigator.pushReplacementNamed(context, LoginScreen.id);
}

class MyIntroductionScreen extends StatelessWidget {
  MyIntroductionScreen({super.key});
  static const String id = 'my introduction screen';
  final List<PageViewModel> pages = [
    CustomPageView.buildPageView(
        title: "Welcome to our app !",
        body:
            "This screen marks the beginning of your learning journey. Create an account to unlock the full potential of the app's features.",
        pathImage: "assets/images/first.jpg"),
    CustomPageView.buildPageView(
        title: "Lesson Selection and Study",
        body:
            "Select a lesson that aligns with your current studies by tapping on its virtual bookshelf. Inside each lesson's file, you'll find a carefully curated list of words for memorization.",
        pathImage: "assets/images/second.png"),
    CustomPageView.buildPageView(
        title: " Testing and Progress Report",
        body:
            "You can test on all words, a randomly selected word, or a word of your choosing.\n Listen to clear pronunciation and then spell the word as prompted.",
        pathImage: "assets/images/third.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          dotsDecorator: const DotsDecorator(
            activeColor: MyColors.textButton,
          ),
          pages: pages,
          done: const CustomText(
            text: "Done",
            color: MyColors.textButton,
          ),
          onDone: () => onDone(context),
          showSkipButton: true,
          skip: const CustomText(
            text: "Skip",
            color: MyColors.textButton,
          ),
          onSkip: () => onDone(context),
          next: const CustomText(
            text: "Next",
            color: MyColors.textButton,
          ),
          curve: Curves.easeIn,
        ),
      ),
    );
  }
}
