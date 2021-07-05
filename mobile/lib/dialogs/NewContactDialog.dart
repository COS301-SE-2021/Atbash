import 'package:flutter/material.dart';

class PhoneNumberNamePair {
  final String phoneNumber;
  final String name;

  PhoneNumberNamePair(this.phoneNumber, this.name);
}

Future<PhoneNumberNamePair?> showNewContactDialog(BuildContext context) {
  return showDialog<PhoneNumberNamePair>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _NewContactDialog());
}

class _NewContactDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
