import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/login_cubit/login_cubit.dart';
import 'package:sm3ly/cubits/register_cubit/register_cubit.dart';
import 'package:sm3ly/screens/about_app_screen.dart';
import 'package:sm3ly/screens/about_us_screen.dart';
import 'package:sm3ly/screens/change_password_screen.dart';
import 'package:sm3ly/screens/my_introduction_screen.dart';
import 'package:sm3ly/screens/splash_screen.dart';
import 'package:sm3ly/screens/test_words_screen.dart';
import 'package:sm3ly/screens/words_screen.dart';
import 'package:sm3ly/screens/home.dart';
import 'package:sm3ly/screens/home_screen.dart';
import 'package:sm3ly/screens/library_screen.dart';
import 'package:sm3ly/screens/login_screen.dart';
import 'package:sm3ly/screens/profile_screen.dart';
import 'package:sm3ly/screens/register_screen.dart';
import 'package:sm3ly/screens/settings_screen.dart';
import 'package:sm3ly/screens/challenge_screen.dart';
import 'package:sm3ly/service/firestore_helper.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';
import 'cubits/user_cubit/user_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper.initial();
  await FirestoreHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChangePasswordCubit()),
        BlocProvider(create: (context) => LibraryCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          LibraryScreen.id: (context) => const LibraryScreen(),
          ChangePasswordScreen.id: (context) => const ChangePasswordScreen(),
          ProfileScreen.id: (context) => const ProfileScreen(),
          SettingsScreen.id: (context) => const SettingsScreen(),
          AboutUsScreen.id: (context) => const AboutUsScreen(),
          AboutAppScreen.id: (context) => const AboutAppScreen(),
          ChallengeScreen.id: (context) => const ChallengeScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          WordsScreen.id: (context) => const WordsScreen(),
          MyIntroductionScreen.id: (context) => MyIntroductionScreen(),
          TestWordsScreen.id: (context) =>  TestWordsScreen(),
          SplashScreen.id: (context) =>  const SplashScreen(),
          Home.id: (context) => const Home(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
