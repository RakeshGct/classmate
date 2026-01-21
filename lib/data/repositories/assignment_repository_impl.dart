import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/assignment.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../datasources/firestore_assignment_datasource.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final FirestoreAssignmentDataSource dataSource;

  AssignmentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Assignment>>> getAssignments(
    String userId,
  ) async {
    try {
      final assignments = await dataSource.getAssignments(userId);
      return Right(assignments.map((a) => a.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Assignment>> createAssignment({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      final assignment = await dataSource.createAssignment(
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
      );
      return Right(assignment.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitAssignment({
    required String assignmentId,
    required File file,
    required String fileName,
  }) async {
    try {
      await dataSource.submitAssignment(
        assignmentId: assignmentId,
        file: file,
        fileName: fileName,
      );
      return const Right(null);
    } catch (e) {
      return Left(FileUploadFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAssignmentStatus({
    required String assignmentId,
    required AssignmentStatus status,
  }) async {
    try {
      await dataSource.updateAssignmentStatus(
        assignmentId: assignmentId,
        status: status,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAssignment(String assignmentId) async {
    try {
      await dataSource.deleteAssignment(assignmentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
