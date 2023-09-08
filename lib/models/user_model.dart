import 'package:sm3ly/constant.dart';

class UserModel {
  // for profile
  String id;
  String email;
  String username;
  int totalNumberOfWords;
  int totalNumberOfClasses;

  // for settings
  bool isMale;
  bool isArabic;
  bool isDarkMode;
  double speakerSpeed;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.totalNumberOfClasses,
    required this.totalNumberOfWords,
    required this.isMale,
    required this.isArabic,
    required this.isDarkMode,
    required this.speakerSpeed,
  });
  factory UserModel.fromJson(Map<String, dynamic> userJson) => UserModel(
        // for profile
        id: userJson[kId],
        username: userJson[kUsername],
        email: userJson[kEmail],
        totalNumberOfClasses: userJson[kTotalNumberOfClasses],
        totalNumberOfWords: userJson[kTotalNumberOfWords],
        // for settings
        isArabic: userJson[kIsArabic],
        isDarkMode: userJson[kIsDarkMode],
        isMale: userJson[kIsMale],
        speakerSpeed: userJson[kSpeakerSpeed],
      );
  Map<String, dynamic> toJson() => {
        // for profile
        kId: id,
        kEmail: email,
        kUsername: username,
        kTotalNumberOfWords: totalNumberOfWords,
        kTotalNumberOfClasses: totalNumberOfClasses,
        // for settings
        kIsArabic: isArabic,
        kIsMale: isMale,
        kIsDarkMode: isDarkMode,
        kSpeakerSpeed: speakerSpeed
      };
}
