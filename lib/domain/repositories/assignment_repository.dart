import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/assignment.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, List<Assignment>>> getAssignments(String userId);

  Future<Either<Failure, Assignment>> createAssignment({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
  });

  Future<Either<Failure, void>> submitAssignment({
    required String assignmentId,
    required File file,
    required String fileName,
  });

  Future<Either<Failure, void>> updateAssignmentStatus({
    required String assignmentId,
    required AssignmentStatus status,
  });

  Future<Either<Failure, void>> deleteAssignment(String assignmentId);
}
