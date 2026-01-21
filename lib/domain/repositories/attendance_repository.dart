import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, void>> markAttendance({
    required String userId,
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  });

  Future<Either<Failure, Attendance?>> getAttendanceByDate({
    required String userId,
    required DateTime date,
  });

  Future<Either<Failure, List<Attendance>>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, Map<String, int>>> getAttendanceStats(String userId);
}
