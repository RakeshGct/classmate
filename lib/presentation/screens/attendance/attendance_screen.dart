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
import '../../widgets/custom_button.dart';
import 'attendance_history_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  AttendanceStatus? _selectedStatus;
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AttendanceBloc>().add(
        GetAttendanceByDateEvent(
          userId: authState.user.uid,
          date: _selectedDate,
        ),
      );
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAttendance();
    }
  }

  void _markAttendance() {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select attendance status')),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AttendanceBloc>().add(
        MarkAttendanceEvent(
          userId: authState.user.uid,
          date: _selectedDate,
          status: _selectedStatus!,
          remarks: _remarksController.text.isEmpty
              ? null
              : _remarksController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.attendance),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AttendanceHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceMarked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.successColor,
              ),
            );
            _loadAttendance();
          } else if (state is AttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is AttendanceLoaded) {
            if (state.attendance != null) {
              setState(() {
                _selectedStatus = state.attendance!.status;
                _remarksController.text = state.attendance!.remarks ?? '';
              });
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.selectDate,
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormatter.formatDateForDisplay(
                                    _selectedDate,
                                  ),
                                  style: AppTextStyles.bodyLarge,
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.status, style: AppTextStyles.heading3),
                        const SizedBox(height: 12),
                        _buildStatusButton(AttendanceStatus.present),
                        const SizedBox(height: 8),
                        _buildStatusButton(AttendanceStatus.absent),
                        const SizedBox(height: 8),
                        _buildStatusButton(AttendanceStatus.leave),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _remarksController,
                          decoration: const InputDecoration(
                            labelText: 'Remarks (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppStrings.markAttendance,
                  onPressed: _markAttendance,
                  isLoading: state is AttendanceLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(AttendanceStatus status) {
    final isSelected = _selectedStatus == status;
    Color color;
    String label;

    switch (status) {
      case AttendanceStatus.present:
        color = AppColors.presentColor;
        label = AppStrings.present;
        break;
      case AttendanceStatus.absent:
        color = AppColors.absentColor;
        label = AppStrings.absent;
        break;
      case AttendanceStatus.leave:
        color = AppColors.leaveColor;
        label = AppStrings.leave;
        break;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
