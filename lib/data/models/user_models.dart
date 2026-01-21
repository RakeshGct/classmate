// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/user.dart';

// class UserModel extends User {
//   const UserModel({
//     required super.uid,
//     required super.email,
//     required super.fullName,
//     required super.studentId,
//     required super.createdAt,
//   });

//   factory UserModel.fromEntity(User user) {
//     return UserModel(
//       uid: user.uid,
//       email: user.email,
//       fullName: user.fullName,
//       studentId: user.studentId,
//       createdAt: user.createdAt,
//     );
//   }

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       uid: json['uid'] as String,
//       email: json['email'] as String,
//       fullName: json['fullName'] as String,
//       studentId: json['studentId'] as String,
//       createdAt: (json['createdAt'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'email': email,
//       'fullName': fullName,
//       'studentId': studentId,
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }

//   User toEntity() {
//     return User(
//       uid: uid,
//       email: email,
//       fullName: fullName,
//       studentId: studentId,
//       createdAt: createdAt,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    required super.fullName,
    required super.studentId,
    required super.createdAt,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      fullName: user.fullName,
      studentId: user.studentId,
      createdAt: user.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        uid: json['uid'] as String? ?? '',
        email: json['email'] as String? ?? '',
        fullName: json['fullName'] as String? ?? '',
        studentId: json['studentId'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? (json['createdAt'] is Timestamp
                  ? (json['createdAt'] as Timestamp).toDate()
                  : json['createdAt'] is String
                  ? DateTime.parse(json['createdAt'] as String)
                  : DateTime.now())
            : DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error parsing user data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'studentId': studentId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  User toEntity() {
    return User(
      uid: uid,
      email: email,
      fullName: fullName,
      studentId: studentId,
      createdAt: createdAt,
    );
  }
}
