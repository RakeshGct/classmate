import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/assignment.dart';

class AssignmentModel extends Assignment {
  const AssignmentModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.status,
    super.fileUrl,
    super.fileName,
    super.submittedAt,
    required super.createdAt,
  });

  factory AssignmentModel.fromEntity(Assignment assignment) {
    return AssignmentModel(
      id: assignment.id,
      userId: assignment.userId,
      title: assignment.title,
      description: assignment.description,
      dueDate: assignment.dueDate,
      status: assignment.status,
      fileUrl: assignment.fileUrl,
      fileName: assignment.fileName,
      submittedAt: assignment.submittedAt,
      createdAt: assignment.createdAt,
    );
  }

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing assignment from JSON: ${json['title']}');

      // Parse status safely
      AssignmentStatus status;
      final statusStr = json['status']?.toString() ?? 'pending';
      try {
        status = AssignmentStatus.values.firstWhere(
          (e) => e.toString().split('.').last == statusStr,
          orElse: () => AssignmentStatus.pending,
        );
      } catch (e) {
        print('Error parsing status: $e, using pending');
        status = AssignmentStatus.pending;
      }

      // Parse dates safely
      DateTime dueDate;
      final dueDateValue = json['dueDate'];
      if (dueDateValue is Timestamp) {
        dueDate = dueDateValue.toDate();
      } else if (dueDateValue is String) {
        dueDate = DateTime.parse(dueDateValue);
      } else if (dueDateValue is int) {
        dueDate = DateTime.fromMillisecondsSinceEpoch(dueDateValue);
      } else {
        dueDate = DateTime.now().add(const Duration(days: 7));
      }

      DateTime createdAt;
      final createdAtValue = json['createdAt'];
      if (createdAtValue is Timestamp) {
        createdAt = createdAtValue.toDate();
      } else if (createdAtValue is String) {
        createdAt = DateTime.parse(createdAtValue);
      } else if (createdAtValue is int) {
        createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
      } else {
        createdAt = DateTime.now();
      }

      DateTime? submittedAt;
      final submittedAtValue = json['submittedAt'];
      if (submittedAtValue != null) {
        if (submittedAtValue is Timestamp) {
          submittedAt = submittedAtValue.toDate();
        } else if (submittedAtValue is String) {
          submittedAt = DateTime.parse(submittedAtValue);
        } else if (submittedAtValue is int) {
          submittedAt = DateTime.fromMillisecondsSinceEpoch(submittedAtValue);
        }
      }

      // Get the document ID
      String id = json['id']?.toString() ?? '';
      if (id.isEmpty) {
        // If id is not in the document, it might be passed separately
        // We'll generate a temporary one
        id = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      }

      final assignment = AssignmentModel(
        id: id,
        userId: json['userId']?.toString() ?? '',
        title: json['title']?.toString() ?? 'Untitled Assignment',
        description: json['description']?.toString() ?? '',
        dueDate: dueDate,
        status: status,
        fileUrl: json['fileUrl']?.toString(),
        fileName: json['fileName']?.toString(),
        submittedAt: submittedAt,
        createdAt: createdAt,
      );

      print('Assignment parsed successfully: ${assignment.title}');
      return assignment;
    } catch (e) {
      print('Error parsing assignment data: $e');
      print('JSON data: $json');
      throw Exception('Error parsing assignment data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.toString().split('.').last,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'submittedAt': submittedAt != null
          ? Timestamp.fromDate(submittedAt!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Assignment toEntity() {
    return Assignment(
      id: id,
      userId: userId,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      fileUrl: fileUrl,
      fileName: fileName,
      submittedAt: submittedAt,
      createdAt: createdAt,
    );
  }
}
