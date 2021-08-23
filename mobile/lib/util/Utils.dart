import 'package:flutter/material.dart';

String cullToE164(String phoneNumber) {
  return phoneNumber.replaceAll(RegExp("(\s|[^0-9]|^0*)"), "");
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
