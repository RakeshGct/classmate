import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceMarked extends AttendanceState {
  final String message;

  const AttendanceMarked(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceLoaded extends AttendanceState {
  final Attendance? attendance;

  const AttendanceLoaded(this.attendance);

  @override
  List<Object?> get props => [attendance];
}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<Attendance> attendanceList;

  const AttendanceHistoryLoaded(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
