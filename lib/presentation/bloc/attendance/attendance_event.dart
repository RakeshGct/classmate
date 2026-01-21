import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceEvent extends AttendanceEvent {
  final String userId;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;

  const MarkAttendanceEvent({
    required this.userId,
    required this.date,
    required this.status,
    this.remarks,
  });

  @override
  List<Object?> get props => [userId, date, status, remarks];
}

class GetAttendanceByDateEvent extends AttendanceEvent {
  final String userId;
  final DateTime date;

  const GetAttendanceByDateEvent({required this.userId, required this.date});

  @override
  List<Object> get props => [userId, date];
}

class GetAttendanceHistoryEvent extends AttendanceEvent {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetAttendanceHistoryEvent({
    required this.userId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate];
}
