import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/attendance.dart';
import '../../repositories/attendance_repository.dart';

class GetAttendanceHistoryUseCase {
  final AttendanceRepository repository;

  GetAttendanceHistoryUseCase(this.repository);

  Future<Either<Failure, List<Attendance>>> call({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getAttendanceHistory(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
