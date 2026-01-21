import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/firestore_attendance_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final FirestoreAttendanceDataSource dataSource;

  AttendanceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> markAttendance({
    required String userId,
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  }) async {
    try {
      await dataSource.markAttendance(
        userId: userId,
        date: date,
        status: status,
        remarks: remarks,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Attendance?>> getAttendanceByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final attendance = await dataSource.getAttendanceByDate(
        userId: userId,
        date: date,
      );
      return Right(attendance?.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final attendanceList = await dataSource.getAttendanceHistory(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(attendanceList.map((a) => a.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAttendanceStats(
    String userId,
  ) async {
    try {
      final attendanceList = await dataSource.getAttendanceHistory(
        userId: userId,
      );

      int present = 0;
      int absent = 0;
      int leave = 0;

      for (var attendance in attendanceList) {
        switch (attendance.status) {
          case AttendanceStatus.present:
            present++;
            break;
          case AttendanceStatus.absent:
            absent++;
            break;
          case AttendanceStatus.leave:
            leave++;
            break;
        }
      }

      return Right({
        'present': present,
        'absent': absent,
        'leave': leave,
        'total': present + absent + leave,
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
