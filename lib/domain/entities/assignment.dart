import 'package:equatable/equatable.dart';

enum AssignmentStatus { pending, submitted, completed, overdue }

class Assignment extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final AssignmentStatus status;
  final String? fileUrl;
  final String? fileName;
  final DateTime? submittedAt;
  final DateTime createdAt;

  const Assignment({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.fileUrl,
    this.fileName,
    this.submittedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    dueDate,
    status,
    fileUrl,
    fileName,
    submittedAt,
    createdAt,
  ];
}
