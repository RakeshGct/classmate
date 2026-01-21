import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/usecases/attendance/get_attendance_by_date_usecase.dart';
import '../../../domain/usecases/attendance/get_attendance_history_usecase.dart';
import '../../../domain/usecases/attendance/mark_attendance_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final MarkAttendanceUseCase markAttendanceUseCase;
  final GetAttendanceByDateUseCase getAttendanceByDateUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;

  AttendanceBloc({
    required this.markAttendanceUseCase,
    required this.getAttendanceByDateUseCase,
    required this.getAttendanceHistoryUseCase,
  }) : super(AttendanceInitial()) {
    on<MarkAttendanceEvent>(_onMarkAttendance);
    on<GetAttendanceByDateEvent>(_onGetAttendanceByDate);
    on<GetAttendanceHistoryEvent>(_onGetAttendanceHistory);
  }

  Future<void> _onMarkAttendance(
    MarkAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await markAttendanceUseCase(
      userId: event.userId,
      date: event.date,
      status: event.status,
      remarks: event.remarks,
    );

    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (_) => emit(const AttendanceMarked(AppStrings.attendanceMarked)),
    );
  }

  Future<void> _onGetAttendanceByDate(
    GetAttendanceByDateEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await getAttendanceByDateUseCase(
      userId: event.userId,
      date: event.date,
    );

    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendance) => emit(AttendanceLoaded(attendance)),
    );
  }

  Future<void> _onGetAttendanceHistory(
    GetAttendanceHistoryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await getAttendanceHistoryUseCase(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendanceList) => emit(AttendanceHistoryLoaded(attendanceList)),
    );
  }
}
