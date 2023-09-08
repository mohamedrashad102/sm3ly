import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/constant.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});
  static const String id = 'about app screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.textButton,
        elevation: 0,
        title: const CustomText(
          text: "About Sam3ly",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Center(
                child: Image.asset(
              "assets/images/first.jpg",
              height: 300,
              width: 300,
            )),
            // ignore: sized_box_for_whitespace
            Container(
              width: 350,
              child: const Center(
                child: CustomText(
                    color: MyColors.gradient1,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    text:
                        "Sam3ly is more than just an app.it's your dedicated study partner, committed to optimizing your learning journey. With its user-friendly interface, innovative testing methods, and personalized performance insights !"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
