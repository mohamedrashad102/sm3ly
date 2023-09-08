import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm3ly/constant.dart';
import 'package:sm3ly/models/class_model.dart';
import 'package:sm3ly/models/user_model.dart';
import '../models/word_model.dart';

class FirestoreHelper {
  static late final FirebaseFirestore _db;

  static init() {
    _db = FirebaseFirestore.instance;
  }

  // for users
  static Future<void> createNewUserDocument(UserModel user) async {
    await _db
        .collection(kUsers)
        .doc(user.id)
        .set(user.toJson()); // for user details
    _db
        .collection(kUsers)
        .doc(user.id)
        .collection(kClasses)
        .doc(); // for classes
  }

  static Future<UserModel> fetchUserData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userData = await _db.collection(kUsers).doc(userId).get();
    UserModel data =
        UserModel.fromJson(userData.data() as Map<String, dynamic>);

    QuerySnapshot classesSnapshot =
        await _db.collection(kUsers).doc(userId).collection(kClasses).get();
    int totalNumberOfClasses = classesSnapshot.docs.length;
    data.totalNumberOfClasses = totalNumberOfClasses;

    int totalNumberOfWords = 0;

    for (QueryDocumentSnapshot classDoc in classesSnapshot.docs) {
      QuerySnapshot wordsSnapshot =
          await classDoc.reference.collection(kWords).get();
      totalNumberOfWords += wordsSnapshot.docs.length;
    }

    data.totalNumberOfWords = totalNumberOfWords;

    return data;
  }

  static Future<void> updateUserData(UserModel user) async {
    await _db.collection(kUsers).doc(user.id).update(user.toJson());
  }

  // for classes
  static DocumentReference _getClassRef(ClassModel currentCLass) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference classRef = _db
        .collection(kUsers)
        .doc(userId)
        .collection(kClasses)
        .doc(currentCLass.id);
    return classRef;
  }

  static Future<void> createNewClass(ClassModel newClass) async {
    DocumentReference classRef = _getClassRef(newClass);
    await classRef.set(newClass.toJson());
    await classRef.collection(kWords).doc('a').set(WordModel(
          arabicWord: kArabicWord,
          englishWord: kEnglishWord,
          id: 'a',
          createdAt: DateTime.now(),
        ).toJson());
  }

  static Future<void> editClassTitle(
      ClassModel currentClass, ClassModel newClass) async {
    DocumentReference classesRef = _getClassRef(currentClass);
    await classesRef.update(newClass.toJson());
  }

  static Future<void> deleteClass(
    ClassModel currentClass,
  ) async {
    DocumentReference classesRef = _getClassRef(currentClass);
    await classesRef.delete();
  }

  static Future<List<ClassModel>> fetchClassesData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot classesRef = await _db
        .collection(kUsers)
        .doc(userId)
        .collection(kClasses)
        .orderBy(kCreatedAt)
        .get();
    List<ClassModel> data =
        classesRef.docs.map((e) => ClassModel.fromJson(e.data())).toList();
    return data;
  }

  // for words

  static DocumentReference _getWordRef(
      ClassModel currentClass, WordModel currentWord) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference wordRef = _db
        .collection(kUsers)
        .doc(userId)
        .collection(kClasses)
        .doc(currentClass.id)
        .collection(kWords)
        .doc(currentWord.id);
    return wordRef;
  }

  static Future<void> createNewWord(
    ClassModel currentClass,
    WordModel newWord,
  ) async {
    try {
      DocumentReference wordRef = _getWordRef(currentClass, newWord);
      await wordRef.set(newWord.toJson());
      debugPrint('Word added successfully.');
    } catch (e) {
      debugPrint('Error adding word: $e');
    }
  }

  static Future<void> editWord({
    required ClassModel currentClass,
    required WordModel newWord,
  }) async {
    try {
      DocumentReference wordRef = _getWordRef(currentClass, newWord);
      await wordRef.update(newWord.toJson());
      debugPrint('Word updated successfully.');
    } catch (e) {
      debugPrint('Error updating word: $e');
    }
  }

  static Future<void> deleteWord({
    required ClassModel currentClass,
    required WordModel currentWord,
  }) async {
    try {
      DocumentReference wordRef = _getWordRef(currentClass, currentWord);
      await wordRef.delete();
      debugPrint('Word deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting word: $e');
    }
  }

  static Future<List<WordModel>> fetchWordsData(ClassModel currentClass) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot wordsRef = await _db
        .collection(kUsers)
        .doc(userId)
        .collection(kClasses)
        .doc(currentClass.id)
        .collection(kWords)
        .orderBy(kCreatedAt)
        .get();
    List<WordModel> data =
        wordsRef.docs.map((e) => WordModel.fromJson(e.data())).toList();
    data.removeAt(0);
    return data;
  }
}
