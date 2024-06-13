import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nourish_me/constants/Constants.dart';

String ParsedateDB(DateTime date) {
  return '${DateFormat.yMMMd().format(date)}';
}

SnackBar popumsg(String text, String message) {
  final snackBar = SnackBar(
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        Text(message),
      ],
    ),
    elevation: 10,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Primary_voilet,
    action: SnackBarAction(
      label: 'Okay',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  return snackBar;
}
