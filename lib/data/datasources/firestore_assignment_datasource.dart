import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/assignment.dart';
import '../models/assignment_model.dart';

abstract class FirestoreAssignmentDataSource {
  Future<List<AssignmentModel>> getAssignments(String userId);
  Future<AssignmentModel> createAssignment({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
  });
  Future<void> submitAssignment({
    required String assignmentId,
    required File file,
    required String fileName,
  });
  Future<void> updateAssignmentStatus({
    required String assignmentId,
    required AssignmentStatus status,
  });
  Future<void> deleteAssignment(String assignmentId);
}

class FirestoreAssignmentDataSourceImpl
    implements FirestoreAssignmentDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirestoreAssignmentDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<List<AssignmentModel>> getAssignments(String userId) async {
    try {
      print('Fetching assignments for user: $userId');

      // Try with orderBy first (requires index)
      try {
        final snapshot = await firestore
            .collection('assignments')
            .where('userId', isEqualTo: userId)
            .orderBy('dueDate', descending: false)
            .get();

        final assignments = snapshot.docs.map((doc) {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;
          return AssignmentModel.fromJson(data);
        }).toList();

        print('Fetched ${assignments.length} assignments');
        return assignments;
      } catch (indexError) {
        // If index doesn't exist, fall back to simple query
        print('Index not ready, using fallback query: $indexError');

        final snapshot = await firestore
            .collection('assignments')
            .where('userId', isEqualTo: userId)
            .get();

        final assignments = snapshot.docs.map((doc) {
          final data = doc.data();
          // Add document ID to the data
          data['id'] = doc.id;
          return AssignmentModel.fromJson(data);
        }).toList();

        // Sort in memory
        assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

        print('Fetched ${assignments.length} assignments (fallback)');
        return assignments;
      }
    } catch (e) {
      print('Error getting assignments: $e');
      print('Error type: ${e.runtimeType}');

      // If error contains "index" or "requires an index"
      if (e.toString().contains('index') ||
          e.toString().contains('requires an index')) {
        throw Exception(
          'Database index is being created. Please wait a few minutes and try again.\n\n'
          'If this persists, click the error link to create the index manually.',
        );
      }

      throw Exception('Failed to get assignments: $e');
    }
  }

  @override
  Future<AssignmentModel> createAssignment({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      final docRef = firestore.collection('assignments').doc();

      final assignment = AssignmentModel(
        id: docRef.id,
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        status: AssignmentStatus.pending,
        createdAt: DateTime.now(),
      );

      await docRef.set(assignment.toJson());

      print('Assignment created successfully');
      return assignment;
    } catch (e) {
      print('Error creating assignment: $e');
      throw Exception('Failed to create assignment: $e');
    }
  }

  @override
  Future<void> submitAssignment({
    required String assignmentId,
    required File file,
    required String fileName,
  }) async {
    try {
      print('Starting file upload...');
      print('File path: ${file.path}');
      print('File name: $fileName');
      print('Assignment ID: $assignmentId');

      // Check if file exists
      if (!await file.exists()) {
        throw Exception('Selected file does not exist');
      }

      // Get file size
      final fileSize = await file.length();
      print('File size: ${fileSize} bytes');

      if (fileSize == 0) {
        throw Exception('Selected file is empty');
      }

      // Create a unique file path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = fileName.split('.').last;
      final uniqueFileName = '${timestamp}_$fileName';
      final storagePath = 'assignments/$assignmentId/$uniqueFileName';

      print('Storage path: $storagePath');

      // Upload file to Firebase Storage
      final storageRef = storage.ref().child(storagePath);

      print('Starting upload task...');
      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(fileExtension),
          customMetadata: {
            'uploadedBy': assignmentId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload progress: ${progress.toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      final taskSnapshot = await uploadTask;
      print('Upload completed. State: ${taskSnapshot.state}');

      if (taskSnapshot.state != TaskState.success) {
        throw Exception('File upload failed with state: ${taskSnapshot.state}');
      }

      // Get download URL
      print('Getting download URL...');
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Download URL obtained: $downloadUrl');

      // Update assignment document in Firestore
      print('Updating Firestore document...');
      await firestore.collection('assignments').doc(assignmentId).update({
        'fileUrl': downloadUrl,
        'fileName': fileName,
        'submittedAt': Timestamp.fromDate(DateTime.now()),
        'status': AssignmentStatus.submitted.toString().split('.').last,
      });

      print('✅ Assignment submitted successfully');
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'storage/unauthorized':
          errorMessage =
              'You do not have permission to upload files. Please check Firebase Storage rules.';
          break;
        case 'storage/canceled':
          errorMessage = 'Upload was cancelled';
          break;
        case 'storage/unknown':
          errorMessage = 'An unknown error occurred: ${e.message}';
          break;
        case 'storage/object-not-found':
          errorMessage = 'File upload failed. Please try again.';
          break;
        case 'storage/quota-exceeded':
          errorMessage = 'Storage quota exceeded';
          break;
        case 'storage/unauthenticated':
          errorMessage = 'User is not authenticated';
          break;
        default:
          errorMessage = 'Upload failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Error submitting assignment: $e');
      throw Exception('Failed to submit assignment: $e');
    }
  }

  // Helper method to determine content type
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<void> updateAssignmentStatus({
    required String assignmentId,
    required AssignmentStatus status,
  }) async {
    try {
      await firestore.collection('assignments').doc(assignmentId).update({
        'status': status.toString().split('.').last,
      });

      print('Assignment status updated');
    } catch (e) {
      print('Error updating assignment status: $e');
      throw Exception('Failed to update assignment status: $e');
    }
  }

  @override
  Future<void> deleteAssignment(String assignmentId) async {
    try {
      await firestore.collection('assignments').doc(assignmentId).delete();
      print('Assignment deleted');
    } catch (e) {
      print('Error deleting assignment: $e');
      throw Exception('Failed to delete assignment: $e');
    }
  }
}
