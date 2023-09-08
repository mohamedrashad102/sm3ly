import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sm3ly/constant.dart';

class WordModel {
  final String arabicWord;
  final String englishWord;
  final String id;
  final DateTime createdAt;

  WordModel({
    required this.arabicWord,
    required this.englishWord,
    required this.id,
    required this.createdAt,
  });

  factory WordModel.fromJson(wordJson) => WordModel(
        arabicWord: wordJson[kArabicWord],
        englishWord: wordJson[kEnglishWord],
        id: wordJson[kId],
        createdAt: wordJson[kCreatedAt].toDate(),
      );
  Map<String, dynamic> toJson() => {
        kArabicWord: arabicWord,
        kEnglishWord: englishWord,
        kId: id,
        kCreatedAt: Timestamp.fromDate(createdAt),
      };
  factory WordModel.fromOfflineJson(wordJson) => WordModel(
        arabicWord: wordJson[kArabicWord],
        englishWord: wordJson[kEnglishWord],
        id: wordJson[kId],
        createdAt: DateTime.parse(wordJson[kCreatedAt]),
      );
  Map<String, dynamic> toOfflineJson() => {
        kArabicWord: arabicWord,
        kEnglishWord: englishWord,
        kId: id,
        kCreatedAt: createdAt.toString(),
      };
  @override
  String toString() {
    return '$englishWord : $arabicWord';
  }
}
