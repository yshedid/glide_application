import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

buildNavigatorPush(context, {required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}
buildNavigatorPushReplacement(context, {required Widget screen}) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
}

// Validators
String? validateIATACode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter airport code';
  }
  if (value.length != 3) {
    return 'Airport code must be 3 letters';
  }
  if (!RegExp(r'^[A-Za-z]{3}$').hasMatch(value)) {
    return 'Airport code must contain only letters';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a date';
  }
  try {
    DateTime date = DateFormat('yyyy-MM-dd').parse(value);
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Date cannot be in the past';
    }
  } catch (e) {
    return 'Invalid date format';
  }
  return null;
}

String? validatePassengers(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter number of passengers';
  }
  int? passengers = int.tryParse(value);
  if (passengers == null || passengers < 1 || passengers > 9) {
    return 'Passengers must be between 1 and 9';
  }
  return null;
}

// formatters
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
