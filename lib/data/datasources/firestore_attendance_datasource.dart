import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attendance.dart';
import '../models/attendance_model.dart';

abstract class FirestoreAttendanceDataSource {
  Future<void> markAttendance({
    required String userId,
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  });

  Future<AttendanceModel?> getAttendanceByDate({
    required String userId,
    required DateTime date,
  });

  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class FirestoreAttendanceDataSourceImpl
    implements FirestoreAttendanceDataSource {
  final FirebaseFirestore firestore;

  FirestoreAttendanceDataSourceImpl({required this.firestore});

  @override
  Future<void> markAttendance({
    required String userId,
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  }) async {
    try {
      final dateKey = DateTime(date.year, date.month, date.day);
      final docId = '${userId}_${dateKey.millisecondsSinceEpoch}';

      final attendance = AttendanceModel(
        id: docId,
        userId: userId,
        date: dateKey,
        status: status,
        remarks: remarks,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection('attendance')
          .doc(docId)
          .set(attendance.toJson(), SetOptions(merge: true));

      print('Attendance marked successfully');
    } catch (e) {
      print('Error marking attendance: $e');
      throw Exception('Failed to mark attendance: $e');
    }
  }

  @override
  Future<AttendanceModel?> getAttendanceByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey = DateTime(date.year, date.month, date.day);
      final docId = '${userId}_${dateKey.millisecondsSinceEpoch}';

      final doc = await firestore.collection('attendance').doc(docId).get();

      if (!doc.exists) {
        print('No attendance record for this date');
        return null;
      }

      return AttendanceModel.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting attendance by date: $e');
      throw Exception('Failed to get attendance: $e');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('Fetching attendance history for user: $userId');

      // Try with orderBy first (requires index)
      try {
        Query query = firestore
            .collection('attendance')
            .where('userId', isEqualTo: userId)
            .orderBy('date', descending: true);

        if (startDate != null) {
          query = query.where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          );
        }

        if (endDate != null) {
          query = query.where(
            'date',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate),
          );
        }

        final snapshot = await query.limit(100).get();

        final attendanceList = snapshot.docs
            .map(
              (doc) =>
                  AttendanceModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

        print('Fetched ${attendanceList.length} attendance records');
        return attendanceList;
      } catch (indexError) {
        // If index doesn't exist, fall back to simple query without ordering
        print('Index not ready, using fallback query: $indexError');

        final snapshot = await firestore
            .collection('attendance')
            .where('userId', isEqualTo: userId)
            .get();

        final attendanceList = snapshot.docs
            .map(
              (doc) =>
                  AttendanceModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

        // Sort in memory
        attendanceList.sort((a, b) => b.date.compareTo(a.date));

        print('Fetched ${attendanceList.length} attendance records (fallback)');
        return attendanceList;
      }
    } catch (e) {
      print('Error getting attendance history: $e');

      // If error contains "index" or "requires an index"
      if (e.toString().contains('index') ||
          e.toString().contains('requires an index')) {
        throw Exception(
          'Database index is being created. Please wait a few minutes and try again.\n\n'
          'If this persists, click the error link to create the index manually.',
        );
      }

      throw Exception('Failed to get attendance history: $e');
    }
  }
}
