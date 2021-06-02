import 'Contact.dart';

class User {
  final String phoneNumber;
  String displayName;
  String status;

  List<Contact> contacts;

  User(this.phoneNumber, this.displayName, this.status, this.contacts);
}
