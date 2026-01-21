import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/assignment.dart';
import '../../repositories/assignment_repository.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<Either<Failure, List<Assignment>>> call(String userId) {
    return repository.getAssignments(userId);
  }
}
