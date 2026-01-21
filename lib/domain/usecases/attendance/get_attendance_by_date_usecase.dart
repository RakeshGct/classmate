import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/attendance.dart';
import '../../repositories/attendance_repository.dart';

class GetAttendanceByDateUseCase {
  final AttendanceRepository repository;

  GetAttendanceByDateUseCase(this.repository);

  Future<Either<Failure, Attendance?>> call({
    required String userId,
    required DateTime date,
  }) {
    return repository.getAttendanceByDate(userId: userId, date: date);
  }
}
