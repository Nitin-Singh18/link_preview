import 'package:flutter/material.dart';

snackBar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Invalid URL. Please enter a valid URL.'),
      duration: Duration(seconds: 2),
    ),
  );
}
