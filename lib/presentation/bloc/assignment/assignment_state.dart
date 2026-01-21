import 'package:equatable/equatable.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentState extends Equatable {
  const AssignmentState();

  @override
  List<Object> get props => [];
}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentsLoaded extends AssignmentState {
  final List<Assignment> assignments;

  const AssignmentsLoaded(this.assignments);

  @override
  List<Object> get props => [assignments];
}

class AssignmentUploaded extends AssignmentState {
  final String message;

  const AssignmentUploaded(this.message);

  @override
  List<Object> get props => [message];
}

class AssignmentStatusUpdated extends AssignmentState {
  final String message;

  const AssignmentStatusUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class AssignmentError extends AssignmentState {
  final String message;

  const AssignmentError(this.message);

  @override
  List<Object> get props => [message];
}
