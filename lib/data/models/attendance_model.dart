import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.status,
    super.remarks,
    required super.createdAt,
  });

  factory AttendanceModel.fromEntity(Attendance attendance) {
    return AttendanceModel(
      id: attendance.id,
      userId: attendance.userId,
      date: attendance.date,
      status: attendance.status,
      remarks: attendance.remarks,
      createdAt: attendance.createdAt,
    );
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
      ),
      remarks: json['remarks'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'status': status.toString().split('.').last,
      'remarks': remarks,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Attendance toEntity() {
    return Attendance(
      id: id,
      userId: userId,
      date: date,
      status: status,
      remarks: remarks,
      createdAt: createdAt,
    );
  }
}
