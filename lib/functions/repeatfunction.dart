import 'package:intl/intl.dart';

String ParsedateDB(DateTime date) {
  return '${DateFormat.yMMMd().format(date)}';
}
