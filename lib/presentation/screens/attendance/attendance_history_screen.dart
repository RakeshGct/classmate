import 'package:classmate/core/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/attendance.dart';
import '../../bloc/attendance/attendance_bloc.dart';
import '../../bloc/attendance/attendance_event.dart';
import '../../bloc/attendance/attendance_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/loading_widget.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AttendanceBloc>().add(
        GetAttendanceHistoryEvent(userId: authState.user.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.attendanceHistory)),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const LoadingWidget();
          } else if (state is AttendanceHistoryLoaded) {
            if (state.attendanceList.isEmpty) {
              return Center(
                child: Text(AppStrings.noData, style: AppTextStyles.bodyLarge),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.attendanceList.length,
              itemBuilder: (context, index) {
                final attendance = state.attendanceList[index];
                return _AttendanceCard(attendance: attendance);
              },
            );
          } else if (state is AttendanceError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.errorColor,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final Attendance attendance;

  const _AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;

    switch (attendance.status) {
      case AttendanceStatus.present:
        statusColor = AppColors.presentColor;
        statusLabel = AppStrings.present;
        break;
      case AttendanceStatus.absent:
        statusColor = AppColors.absentColor;
        statusLabel = AppStrings.absent;
        break;
      case AttendanceStatus.leave:
        statusColor = AppColors.leaveColor;
        statusLabel = AppStrings.leave;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatDateForDisplay(attendance.date),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (attendance.remarks != null) ...[
              const SizedBox(height: 8),
              Text(
                attendance.remarks!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
