import 'package:intl/intl.dart';

bool validatePhoneNumber(String value) {
  if (value.isEmpty) {
    return false;
  }
  // Updated pattern to match exactly 8 digits
  const pattern = r'^[0-9]{8}$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

String formatDate(DateTime date) {
  return DateFormat('MMMM dd, yyyy').format(date);
}
