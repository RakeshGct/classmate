import 'package:classmate/domain/usecases/assignment/get_assignment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/usecases/assignment/submit_assignment_usecase.dart';
import '../../../domain/usecases/assignment/upload_assignment_usecase.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final GetAssignmentsUseCase getAssignmentsUseCase;
  final UploadAssignmentUseCase uploadAssignmentUseCase;
  final SubmitAssignmentUseCase submitAssignmentUseCase;

  AssignmentBloc({
    required this.getAssignmentsUseCase,
    required this.uploadAssignmentUseCase,
    required this.submitAssignmentUseCase,
  }) : super(AssignmentInitial()) {
    on<GetAssignmentsEvent>(_onGetAssignments);
    on<UploadAssignmentEvent>(_onUploadAssignment);
    on<UpdateAssignmentStatusEvent>(_onUpdateAssignmentStatus);
  }

  Future<void> _onGetAssignments(
    GetAssignmentsEvent event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());

    final result = await getAssignmentsUseCase(event.userId);

    result.fold(
      (failure) => emit(AssignmentError(failure.message)),
      (assignments) => emit(AssignmentsLoaded(assignments)),
    );
  }

  Future<void> _onUploadAssignment(
    UploadAssignmentEvent event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());

    final result = await uploadAssignmentUseCase(
      assignmentId: event.assignmentId,
      file: event.file,
      fileName: event.fileName,
    );

    result.fold(
      (failure) => emit(AssignmentError(failure.message)),
      (_) => emit(const AssignmentUploaded(AppStrings.assignmentSubmitted)),
    );
  }

  Future<void> _onUpdateAssignmentStatus(
    UpdateAssignmentStatusEvent event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());

    final result = await submitAssignmentUseCase(
      assignmentId: event.assignmentId,
      status: event.status,
    );

    result.fold(
      (failure) => emit(AssignmentError(failure.message)),
      (_) => emit(const AssignmentStatusUpdated('Status updated successfully')),
    );
  }
}
