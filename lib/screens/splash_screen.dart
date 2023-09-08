// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/user_cubit/user_cubit.dart';
import 'package:sm3ly/screens/home.dart';
import 'package:sm3ly/screens/login_screen.dart';
import 'package:sm3ly/screens/my_introduction_screen.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final String initialScreen = SharedPreferencesHelper.isFirstTime()
        ? MyIntroductionScreen.id
        : SharedPreferencesHelper.isLogin()
            ? Home.id
            : LoginScreen.id;
    if (initialScreen == Home.id) {
      UserCubit.get(context).fetchUserData();
      LibraryCubit.get(context).fetchLibraryData();
    }
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushNamed(context, initialScreen);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/splash.png",
              height: 120,
              width: 120,
            ),
            const CustomText(
              fontSize: 25,
              text: "Sam3ly",
              color: Color(0xff51518d),
            )
          ],
        ),
      ),
    );
  }
}
