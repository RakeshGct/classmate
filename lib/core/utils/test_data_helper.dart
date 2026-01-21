import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestDataHelper {
  static Future<void> createSampleAttendance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        throw Exception('Please login first');
      }

      final firestore = FirebaseFirestore.instance;

      print('Creating sample attendance records...');
      for (int i = 0; i < 10; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateKey = DateTime(date.year, date.month, date.day);
        final docId = '${user.uid}_${dateKey.millisecondsSinceEpoch}';

        String status;
        if (i % 3 == 0) {
          status = 'present';
        } else if (i % 3 == 1) {
          status = 'absent';
        } else {
          status = 'leave';
        }

        await firestore.collection('attendance').doc(docId).set({
          'id': docId,
          'userId': user.uid,
          'date': Timestamp.fromDate(dateKey),
          'status': status,
          'remarks': i % 2 == 0 ? 'Sample remark for day $i' : null,
          'createdAt': Timestamp.now(),
        });
      }

      print('✅ Created 10 sample attendance records');
    } catch (e) {
      print('❌ Error creating attendance: $e');
      rethrow;
    }
  }

  static Future<void> createSampleAssignments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        throw Exception('Please login first');
      }

      final firestore = FirebaseFirestore.instance;

      print('Creating sample assignments...');

      // Assignment 1 - Due tomorrow (Pending)
      final doc1 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'Math Assignment - Algebra',
        'description':
            'Complete exercises 1-20 from Chapter 5. Show all working steps. Submit solutions in PDF format.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1)),
        ),
        'status': 'pending',
        'fileUrl': null,
        'fileName': null,
        'submittedAt': null,
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 1: ${doc1.id}');

      // Assignment 2 - Due in 3 days (Pending)
      final doc2 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'Science Project - Solar System',
        'description':
            'Create a presentation about the solar system. Include at least 8 planets with their characteristics.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 3)),
        ),
        'status': 'pending',
        'fileUrl': null,
        'fileName': null,
        'submittedAt': null,
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 2: ${doc2.id}');

      // Assignment 3 - Due in 5 days (Pending)
      final doc3 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'English Essay - My Hobbies',
        'description':
            'Write a 500-word essay about your hobbies and interests. Use proper grammar and formatting.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 5)),
        ),
        'status': 'pending',
        'fileUrl': null,
        'fileName': null,
        'submittedAt': null,
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 3: ${doc3.id}');

      // Assignment 4 - Due in 7 days (Pending)
      final doc4 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'History Assignment - Independence Day',
        'description':
            'Research and write about the significance of Independence Day. Include historical events and their impact.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7)),
        ),
        'status': 'pending',
        'fileUrl': null,
        'fileName': null,
        'submittedAt': null,
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 4: ${doc4.id}');

      // Assignment 5 - Overdue (Past date)
      final doc5 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'Computer Lab - Programming Basics',
        'description':
            'Write a simple calculator program in Python. Include all basic operations.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'status': 'pending',
        'fileUrl': null,
        'fileName': null,
        'submittedAt': null,
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 5: ${doc5.id}');

      // Assignment 6 - Already submitted
      final doc6 = await firestore.collection('assignments').add({
        'userId': user.uid,
        'title': 'Physics Lab Report',
        'description':
            'Submit lab report for the pendulum experiment conducted last week.',
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 2)),
        ),
        'status': 'submitted',
        'fileName': 'physics_lab_report.pdf',
        'fileUrl': 'https://example.com/sample.pdf',
        'submittedAt': Timestamp.now(),
        'createdAt': Timestamp.now(),
      });
      print('Created assignment 6: ${doc6.id}');

      print(
        '✅ Created 6 sample assignments (4 pending, 1 overdue, 1 submitted)',
      );
    } catch (e) {
      print('❌ Error creating assignments: $e');
      rethrow;
    }
  }

  static Future<void> createAllSampleData() async {
    try {
      await createSampleAttendance();
      await createSampleAssignments();
      print('🎉 All sample data created successfully!');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  static Future<void> clearAllData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please login first');
      }

      final firestore = FirebaseFirestore.instance;

      print('Deleting attendance records...');
      final attendanceSnapshot = await firestore
          .collection('attendance')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in attendanceSnapshot.docs) {
        await doc.reference.delete();
      }

      print('Deleting assignments...');
      final assignmentSnapshot = await firestore
          .collection('assignments')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in assignmentSnapshot.docs) {
        await doc.reference.delete();
      }

      print('✅ All test data deleted');
    } catch (e) {
      print('❌ Error deleting data: $e');
      rethrow;
    }
  }
}
