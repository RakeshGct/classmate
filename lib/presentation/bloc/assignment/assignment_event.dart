import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentEvent extends Equatable {
  const AssignmentEvent();

  @override
  List<Object?> get props => [];
}

class GetAssignmentsEvent extends AssignmentEvent {
  final String userId;

  const GetAssignmentsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UploadAssignmentEvent extends AssignmentEvent {
  final String assignmentId;
  final File file;
  final String fileName;

  const UploadAssignmentEvent({
    required this.assignmentId,
    required this.file,
    required this.fileName,
  });

  @override
  List<Object> get props => [assignmentId, file, fileName];
}

class UpdateAssignmentStatusEvent extends AssignmentEvent {
  final String assignmentId;
  final AssignmentStatus status;

  const UpdateAssignmentStatusEvent({
    required this.assignmentId,
    required this.status,
  });

  @override
  List<Object> get props => [assignmentId, status];
}
