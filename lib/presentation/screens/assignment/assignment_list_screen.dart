import 'package:classmate/core/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/assignment.dart';
import '../../bloc/assignment/assignment_bloc.dart';
import '../../bloc/assignment/assignment_event.dart';
import '../../bloc/assignment/assignment_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/loading_widget.dart';
import 'assignment_upload_screen.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AssignmentBloc>().add(
        GetAssignmentsEvent(authState.user.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.assignments)),
      body: BlocConsumer<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state is AssignmentUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.successColor,
              ),
            );
            _loadAssignments();
          }
        },
        builder: (context, state) {
          if (state is AssignmentLoading) {
            return const LoadingWidget();
          } else if (state is AssignmentsLoaded) {
            if (state.assignments.isEmpty) {
              return Center(
                child: Text(AppStrings.noData, style: AppTextStyles.bodyLarge),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadAssignments();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.assignments.length,
                itemBuilder: (context, index) {
                  final assignment = state.assignments[index];
                  return _AssignmentCard(
                    assignment: assignment,
                    onTap: () {
                      if (assignment.status == AssignmentStatus.pending) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AssignmentUploadScreen(assignment: assignment),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          } else if (state is AssignmentError) {
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

class _AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onTap;

  const _AssignmentCard({required this.assignment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;

    switch (assignment.status) {
      case AssignmentStatus.pending:
        statusColor = AppColors.pendingColor;
        statusLabel = AppStrings.pending;
        break;
      case AssignmentStatus.submitted:
      case AssignmentStatus.completed:
        statusColor = AppColors.submittedColor;
        statusLabel = AppStrings.submitted;
        break;
      case AssignmentStatus.overdue:
        statusColor = AppColors.overdueColor;
        statusLabel = AppStrings.overdue;
        break;
    }

    final isOverdue =
        assignment.dueDate.isBefore(DateTime.now()) &&
        assignment.status == AssignmentStatus.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: AppTextStyles.heading3,
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
              const SizedBox(height: 8),
              Text(
                assignment.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue
                        ? AppColors.errorColor
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${DateFormatter.formatDate(assignment.dueDate)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isOverdue
                          ? AppColors.errorColor
                          : AppColors.textSecondary,
                      fontWeight: isOverdue
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (assignment.fileName != null) ...[
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.attach_file,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        assignment.fileName!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (assignment.status == AssignmentStatus.pending)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.upload_file),
                          label: const Text(AppStrings.uploadAssignment),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
