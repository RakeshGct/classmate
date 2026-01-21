import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/attendance.dart';
import '../../repositories/attendance_repository.dart';

class MarkAttendanceUseCase {
  final AttendanceRepository repository;

  MarkAttendanceUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  }) {
    return repository.markAttendance(
      userId: userId,
      date: date,
      status: status,
      remarks: remarks,
    );
  }
}
