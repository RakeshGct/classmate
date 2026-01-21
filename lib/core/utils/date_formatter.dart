import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateForDisplay(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy').format(date);
  }

  static String formatDateForStorage(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime parseDateFromStorage(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  static String getMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now) && !isToday(date);
  }

  static bool isFuture(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now) && !isToday(date);
  }
}
