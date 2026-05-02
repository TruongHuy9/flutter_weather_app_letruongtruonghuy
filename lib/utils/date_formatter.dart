import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFull(DateTime date) {
    return DateFormat.yMMMMEEEEd('vi').format(date);
  }
  static String format12Hour(DateTime dateTime) {
    return DateFormat('hh:mm a, EEEE, dd/MM', 'vi_VN').format(dateTime);
  }
  static String formatHour(DateTime date) {
    return DateFormat.Hm().format(date);
  }
}