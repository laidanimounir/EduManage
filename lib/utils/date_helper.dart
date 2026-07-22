import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static String formatDate(DateTime date, String locale) {
    if (locale == 'ar') {
      return DateFormat('yyyy/MM/dd', 'ar').format(date);
    }
    return DateFormat('dd/MM/yyyy', 'fr').format(date);
  }

  static String formatDateTime(DateTime dateTime, String locale) {
    if (locale == 'ar') {
      return DateFormat('yyyy/MM/dd HH:mm', 'ar').format(dateTime);
    }
    return DateFormat('dd/MM/yyyy HH:mm', 'fr').format(dateTime);
  }

  static String formatTime(DateTime time, String locale) {
    if (locale == 'ar') {
      return DateFormat('HH:mm', 'ar').format(time);
    }
    return DateFormat('HH:mm', 'fr').format(time);
  }

  static String formatMonthYear(DateTime date, String locale) {
    if (locale == 'ar') {
      return DateFormat('MMMM yyyy', 'ar').format(date);
    }
    return DateFormat('MMMM yyyy', 'fr').format(date);
  }

  static String formatDayOfWeek(int dayIndex, String locale) {
    final daysAr = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    final daysFr = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    final index = dayIndex - 1;
    if (index < 0 || index >= 7) return '';
    return locale == 'ar' ? daysAr[index] : daysFr[index];
  }

  static bool isTimeInRange(
    DateTime timeToCheck,
    DateTime startTime,
    DateTime endTime,
  ) {
    final check = _toMinutes(timeToCheck);
    final start = _toMinutes(startTime);
    final end = _toMinutes(endTime);
    return check >= start && check <= end;
  }

  static int _toMinutes(DateTime time) {
    return time.hour * 60 + time.minute;
  }

  static bool isCurrentDayMatch(int dayOfWeek) {
    return DateTime.now().weekday == dayOfWeek;
  }

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
