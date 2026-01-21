import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/assignment_repository.dart';

class UploadAssignmentUseCase {
  final AssignmentRepository repository;

  UploadAssignmentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String assignmentId,
    required File file,
    required String fileName,
  }) {
    return repository.submitAssignment(
      assignmentId: assignmentId,
      file: file,
      fileName: fileName,
    );
  }
}
