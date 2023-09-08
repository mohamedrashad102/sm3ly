import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sm3ly/constant.dart';

class ClassModel {
  final String title;
  final String id;
  final DateTime createdAt;

  ClassModel({required this.id, required this.title, required this.createdAt});

  factory ClassModel.fromJson(jsonClass) => ClassModel(
        id: jsonClass[kId],
        title: jsonClass[kTitle],
        createdAt: jsonClass[kCreatedAt].toDate(),
      );
  factory ClassModel.fromOfflineJson(jsonClass) => ClassModel(
        id: jsonClass[kId],
        title: jsonClass[kTitle],
        createdAt: DateTime.parse(jsonClass[kCreatedAt]),
      );

  Map<String, dynamic> toJson() => {
        kId: id,
        kTitle: title,
        kCreatedAt: Timestamp.fromDate(createdAt),
      };

  Map<String, dynamic> toOfflineJson() => {
        kId: id,
        kTitle: title,
        kCreatedAt: createdAt.toString(),
      };

}
