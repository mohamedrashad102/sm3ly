import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sm3ly/models/class_model.dart';
import 'package:sm3ly/models/user_model.dart';
import 'package:sm3ly/models/word_model.dart';

class SharedPreferencesHelper {
  static late final SharedPreferences _pref;

  static const String _isLogin = 'isLogin';
  static const String _isFirstTime = 'isFirstTime';
  static const String _classesData = 'classesData';
  static const String _wordsData = 'wordsData';
  static const String _userData = 'userData';

  static Future<void> initial() async {
    _pref = await SharedPreferences.getInstance();
    if (_pref.getBool(_isLogin) == null) {
      await _pref.setBool(_isLogin, false);
    }
    if (_pref.getBool(_isFirstTime) == null) {
      await _pref.setBool(_isFirstTime, true);
    }
    if (_pref.getString(_classesData) == null) {
      await _pref.setString(_classesData, jsonEncode([]));
    }
    if (_pref.getString(_wordsData) == null) {
      await _pref.setString(_wordsData, jsonEncode([[]]));
    }
    if (_pref.getString(_userData) == null) {
      UserModel newUser = UserModel(
        id: 'userId',
        username: 'username',
        email: 'email',
        totalNumberOfClasses: 0,
        totalNumberOfWords: 0,
        isArabic: false,
        isDarkMode: false,
        isMale: false,
        speakerSpeed: 4,
      );
      await _pref.setString(_wordsData, jsonEncode(newUser.toJson()));
    }
  }

  // login
  static Future<void> setIsLogin(bool value) async {
    await _pref.setBool(_isLogin, value);
  }

  static bool isLogin() {
    return _pref.getBool(_isLogin) ?? false;
  }

  // for introduction screen
  static Future<void> setIsFirstTime(bool value) async {
    await _pref.setBool(_isFirstTime, value);
  }

  static bool isFirstTime() {
    return _pref.getBool(_isFirstTime) ?? true;
  }

  // for classes
  static Future<void> setClassesData(List<ClassModel> classesData) async {
    try {
      String classesJsonData =
          jsonEncode(classesData.map((e) => e.toOfflineJson()).toList());
      await _pref.setString(_classesData, classesJsonData);
      debugPrint('set classes data done');
    } catch (e) {
      debugPrint('error while store classes: ${e.toString()}');
    }
  }

  static List<ClassModel> getClassesData() {
    try {
      List<Map<String, dynamic>> classesJsonData =
          List<Map<String, dynamic>>.from(
              jsonDecode(_pref.getString(_classesData)!));

      List<ClassModel> data =
          classesJsonData.map((e) => ClassModel.fromOfflineJson(e)).toList();
      debugPrint('get classes data done');
      
      return data;
    } catch (e) {
      debugPrint('error while get classes ${e.toString()}');
      return [];
    }
  }

  // for words
  static Future<void> setWordsData(List<List<WordModel>> wordsData) async {
    try {
      String wordsJsonData = jsonEncode(wordsData
          .map((list) => list.map((word) => word.toOfflineJson()).toList())
          .toList());
      await _pref.setString(_wordsData, wordsJsonData);
      debugPrint('set words done');
    } catch (e) {
      debugPrint('error while set words: ${e.toString()}');
    }
  }

  static List<List<WordModel>> getWordsData() {
    List<List<WordModel>> wordsData = [];
    try {
      List<dynamic> wordsJsonData = jsonDecode(_pref.getString(_wordsData)!);

      for (var listJson in wordsJsonData) {
        List<WordModel> wordList = (listJson as List)
            .map((wordJson) => WordModel.fromOfflineJson(wordJson))
            .toList();
        wordsData.add(wordList);
        debugPrint('get words done');
      }
    } catch (e) {
      debugPrint('error while get words: ${e.toString()}');
    }
    return wordsData;
  }

  static Future<void> setUserData(UserModel user) async {
    String userJsonData = jsonEncode(user.toJson());
    await _pref.setString(_userData, userJsonData);
  }

  static UserModel getUserData() {
    String userJsonData = _pref.getString(_userData)!;
    Map<String, dynamic> userData = jsonDecode(userJsonData);
    return UserModel.fromJson(userData);
  }
}
