// import 'dart:io';
// import 'package:classmate/core/constants/app_text_style.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_strings.dart';

// import '../../../core/utils/date_formatter.dart';
// import '../../../domain/entities/assignment.dart';
// import '../../bloc/assignment/assignment_bloc.dart';
// import '../../bloc/assignment/assignment_event.dart';
// import '../../bloc/assignment/assignment_state.dart';
// import '../../widgets/custom_button.dart';

// class AssignmentUploadScreen extends StatefulWidget {
//   final Assignment assignment;

//   const AssignmentUploadScreen({super.key, required this.assignment});

//   @override
//   State<AssignmentUploadScreen> createState() => _AssignmentUploadScreenState();
// }

// class _AssignmentUploadScreenState extends State<AssignmentUploadScreen> {
//   File? _selectedFile;
//   String? _fileName;

//   Future<void> _pickFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx'],
//       );

//       if (result != null) {
//         setState(() {
//           _selectedFile = File(result.files.single.path!);
//           _fileName = result.files.single.name;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error picking file: $e'),
//           backgroundColor: AppColors.errorColor,
//         ),
//       );
//     }
//   }

//   void _submitAssignment() {
//     if (_selectedFile == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please select a file')));
//       return;
//     }

//     context.read<AssignmentBloc>().add(
//       UploadAssignmentEvent(
//         assignmentId: widget.assignment.id,
//         file: _selectedFile!,
//         fileName: _fileName!,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(AppStrings.uploadAssignment)),
//       body: BlocConsumer<AssignmentBloc, AssignmentState>(
//         listener: (context, state) {
//           if (state is AssignmentUploaded) {
//             Navigator.of(context).pop();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.successColor,
//               ),
//             );
//           } else if (state is AssignmentError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorColor,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is AssignmentLoading;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.assignment.title,
//                           style: AppTextStyles.heading2,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.assignment.description,
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.calendar_today,
//                               size: 16,
//                               color: AppColors.textSecondary,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Due: ${DateFormatter.formatDate(widget.assignment.dueDate)}',
//                               style: AppTextStyles.bodySmall.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppStrings.selectFile,
//                           style: AppTextStyles.heading3,
//                         ),
//                         const SizedBox(height: 16),
//                         InkWell(
//                           onTap: _pickFile,
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.borderColor,
//                                 style: BorderStyle.solid,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.upload_file,
//                                   color: AppColors.primaryColor,
//                                   size: 32,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _fileName ?? AppStrings.noFileSelected,
//                                         style: AppTextStyles.bodyMedium
//                                             .copyWith(
//                                               fontWeight: _fileName != null
//                                                   ? FontWeight.w600
//                                                   : FontWeight.normal,
//                                             ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         'Tap to select PDF or DOC file',
//                                         style: AppTextStyles.caption,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Icon(Icons.arrow_forward_ios, size: 16),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 CustomButton(
//                   text: AppStrings.submitAssignment,
//                   onPressed: _submitAssignment,
//                   isLoading: isLoading,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:classmate/core/constants/app_text_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/assignment.dart';
import '../../bloc/assignment/assignment_bloc.dart';
import '../../bloc/assignment/assignment_event.dart';
import '../../bloc/assignment/assignment_state.dart';

class AssignmentUploadScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentUploadScreen({super.key, required this.assignment});

  @override
  State<AssignmentUploadScreen> createState() => _AssignmentUploadScreenState();
}

class _AssignmentUploadScreenState extends State<AssignmentUploadScreen> {
  File? _selectedFile;
  String? _fileName;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    try {
      print('Opening file picker...');

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;

        print('File picked: ${pickedFile.name}');
        print('File path: ${pickedFile.path}');
        print('File size: ${pickedFile.size} bytes');

        if (pickedFile.path == null) {
          throw Exception('File path is null');
        }

        final file = File(pickedFile.path!);

        // Verify file exists
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }

        // Check file size (max 10MB)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          throw Exception('File size must be less than 10MB');
        }

        if (fileSize == 0) {
          throw Exception('Selected file is empty');
        }

        setState(() {
          _selectedFile = file;
          _fileName = pickedFile.name;
        });

        print('✅ File selected successfully: $_fileName');
      } else {
        print('File picker cancelled');
      }
    } catch (e) {
      print('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: AppColors.errorColor,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _submitAssignment() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file first'),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Assignment'),
        content: Text('Are you sure you want to submit "$_fileName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isUploading = true);

      print('Starting assignment submission...');
      context.read<AssignmentBloc>().add(
        UploadAssignmentEvent(
          assignmentId: widget.assignment.id,
          file: _selectedFile!,
          fileName: _fileName!,
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.uploadAssignment)),
      body: BlocConsumer<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state is AssignmentUploaded) {
            print('✅ Upload successful');
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.successColor,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is AssignmentError) {
            print('❌ Upload failed: ${state.message}');
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: _submitAssignment,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Assignment Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.assignment.title,
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.assignment.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due: ${DateFormatter.formatDate(widget.assignment.dueDate)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // File Selection Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.selectFile,
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Accepted formats: PDF, DOC, DOCX, TXT (Max 10MB)',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _isUploading ? null : _pickFile,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedFile != null
                                    ? AppColors.primaryColor
                                    : AppColors.borderColor,
                                width: _selectedFile != null ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: _selectedFile != null
                                  ? AppColors.primaryColor.withOpacity(0.05)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedFile != null
                                      ? Icons.check_circle
                                      : Icons.upload_file,
                                  color: _selectedFile != null
                                      ? AppColors.primaryColor
                                      : AppColors.textSecondary,
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _fileName ?? AppStrings.noFileSelected,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: _fileName != null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: _selectedFile != null
                                                  ? AppColors.primaryColor
                                                  : AppColors.textPrimary,
                                            ),
                                      ),
                                      if (_selectedFile != null) ...[
                                        const SizedBox(height: 4),
                                        FutureBuilder<int>(
                                          future: _selectedFile!.length(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                _formatFileSize(snapshot.data!),
                                                style: AppTextStyles.caption,
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                      ] else
                                        Text(
                                          'Tap to select a file',
                                          style: AppTextStyles.caption,
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  _selectedFile != null
                                      ? Icons.edit
                                      : Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isUploading || _selectedFile == null)
                        ? null
                        : _submitAssignment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor: AppColors.textHint,
                    ),
                    child: _isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('Uploading...', style: AppTextStyles.button),
                            ],
                          )
                        : Text(
                            AppStrings.submitAssignment,
                            style: AppTextStyles.button,
                          ),
                  ),
                ),

                if (_isUploading) ...[
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Please wait while your file is being uploaded...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
