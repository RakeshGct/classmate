import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent, leave }

class Attendance extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;
  final DateTime createdAt;

  const Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    this.remarks,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, date, status, remarks, createdAt];
}
