import 'package:flutter/material.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/components/custom_text_button.dart';
import 'package:sm3ly/screens/about_app_screen.dart';
import 'package:sm3ly/screens/about_us_screen.dart';
import 'package:sm3ly/screens/profile_screen.dart';
import 'package:sm3ly/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = 'home screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.appBar,
        title: const CustomText(
          text: 'Home',
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomTextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProfileScreen.id);
                },
                text: 'Profile'),
            const SizedBox(
              height: 20,
            ),
            CustomTextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.id);
                },
                text: 'Settings'),
            const SizedBox(
              height: 20,
            ),
            CustomTextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AboutAppScreen.id);
                },
                text: 'About Sm3ly'),
            const SizedBox(
              height: 20,
            ),
            CustomTextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AboutUsScreen.id);
                },
                text: 'About us'),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
