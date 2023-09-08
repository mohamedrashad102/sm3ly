import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/components/custom_text.dart';
import 'package:sm3ly/components/delete_button.dart';
import 'package:sm3ly/cubits/user_cubit/user_states.dart';
import 'package:sm3ly/helpers/has_network.dart';
import 'package:sm3ly/models/user_model.dart';
import 'package:sm3ly/screens/change_password_screen.dart';
import 'package:sm3ly/service/firestore_helper.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';

import '../library_cubit/library_cubit.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);
  late UserModel currentUser;

  Future<void> fetchUserData() async {
    if (await hasNetwork()) {
      emit(UserLoadingState());
      currentUser = await FirestoreHelper.fetchUserData();
      SharedPreferencesHelper.setUserData(currentUser);
      emit(UserSuccessState());
    } else {
      emit(UserLoadingState());
      currentUser = SharedPreferencesHelper.getUserData();
      emit(UserSuccessState());
    }
  }

  Future<void> incrementSpeakerSpeed(BuildContext context) async {
    if (!await hasNetwork()) {
      emit(UserErrorState('No internet Connection'));
      return;
    }
    if (currentUser.speakerSpeed < 9) {
      currentUser.speakerSpeed++;
      if (context.mounted) {
        double newSpeed = currentUser.speakerSpeed / 10;
        LibraryCubit.get(context).flutterTts.setSpeechRate(newSpeed);
        LibraryCubit.get(context).flutterTts.speak('speaker speed test');
      }
      emit(UserSuccessState());
      await FirestoreHelper.updateUserData(currentUser);
      await SharedPreferencesHelper.setUserData(currentUser);
    }
  }

  Future<void> decrementSpeakerSpeed(BuildContext context) async {
    if (!await hasNetwork()) {
      emit(UserErrorState('No internet Connection'));
      return;
    }
    if (currentUser.speakerSpeed > 1) {
      currentUser.speakerSpeed--;
      if (context.mounted) {
        double newSpeed = currentUser.speakerSpeed / 10;
        LibraryCubit.get(context).flutterTts.setSpeechRate(newSpeed);
        LibraryCubit.get(context).flutterTts.speak('speaker speed test');
      }
      emit(UserSuccessState());
      await FirestoreHelper.updateUserData(currentUser);
      await SharedPreferencesHelper.setUserData(currentUser);
    }
  }

  Future<void> voiceTypeOnToggle(BuildContext context, int index) async {
    if (!await hasNetwork()) {
      emit(UserErrorState('No internet Connection'));
      return;
    }
    emit(UserChangeVoiceTypeLoadingState());
    if (index == 0) {
      currentUser.isMale = true;

      var currentVoice = {"name": "en-gb-x-rjs-local", "locale": "en-GB"};
      if (context.mounted){
        await LibraryCubit.get(context).flutterTts.setVoice(currentVoice);
      }
      
    } else if (index == 1) {
      currentUser.isMale = false;

      var currentVoice = {"name": "en-us-x-tpc-local", "locale": "en-US"};
      if (context.mounted){
        await LibraryCubit.get(context).flutterTts.setVoice(currentVoice);
      }
     
    }
    emit(UserSuccessState());
    await FirestoreHelper.updateUserData(currentUser);
    await SharedPreferencesHelper.setUserData(currentUser);
  }

  // Language
  Future<void> languageOnToggle(int? index) async {
    if (!await hasNetwork()) {
      emit(UserErrorState('No internet Connection'));
      return;
    }
    if (index == 0) {
      // currentUser.isArabic = true;
      // FirestoreHelper.updateUserData(currentUser);
      emit(UserErrorState('Coming soon'));
    } else if (index == 1) {
      currentUser.isArabic = false;
      emit(UserSuccessState());
      await FirestoreHelper.updateUserData(currentUser);
      await SharedPreferencesHelper.setUserData(currentUser);
    }
  }

  // Appearance
  Future<void> appearanceOnToggle(int? index) async {
    if (!await hasNetwork()) {
      emit(UserErrorState('No internet Connection'));
      return;
    }
    if (index == 0) {
      currentUser.isDarkMode = false;
      emit(UserSuccessState());
      await FirestoreHelper.updateUserData(currentUser);
      await SharedPreferencesHelper.setUserData(currentUser);
    } else if (index == 1) {
      // user.isDarkMode = true;
      emit(UserErrorState('Coming soon'));
    }
  }

  void changePasswordOnPressed(BuildContext context) {
    Navigator.pushNamed(context, ChangePasswordScreen.id);
  }

  void deleteAccountOnPressed() {
    emit(UserErrorState('Coming soon'));
  }

  Future<void> logout(BuildContext context) async {
    if (await hasNetwork() && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DeleteButton(
                      color: Colors.green,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Cancel"),
                  DeleteButton(
                    onPressed: () async {
                      if (await hasNetwork()) {
                        emit(UserLoadingState());
                        await FirebaseAuth.instance.signOut();
                        SharedPreferencesHelper.setIsLogin(false);
                        emit(UserSuccessSignOutState());
                      } else {
                        emit(UserErrorState('No internet connection'));
                      }
                    },
                    text: "Log out",
                    color: Colors.red,
                  )
                ],
              )
            ],
            contentPadding: const EdgeInsets.all(20),
            content: const CustomText(
              text: 'Do you want to log out?',
              color: Colors.black,
            )),
      );
    } else {
      emit(UserErrorState('No network connection'));
    }
  }
}
