import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/assignment.dart';
import '../../repositories/assignment_repository.dart';

class SubmitAssignmentUseCase {
  final AssignmentRepository repository;

  SubmitAssignmentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String assignmentId,
    required AssignmentStatus status,
  }) {
    return repository.updateAssignmentStatus(
      assignmentId: assignmentId,
      status: status,
    );
  }
}
