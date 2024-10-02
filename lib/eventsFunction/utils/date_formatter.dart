import 'package:intl/intl.dart';

String formatDate(String dateString) {
  final DateTime parsedDate = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('yyyy MMMM d');
  return formatter.format(parsedDate);
}
