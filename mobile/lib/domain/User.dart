import 'dart:collection';

import 'Contact.dart';

class User {
  final String phoneNumber;
  String displayName;
  String status;

  List<Contact> _contacts = [];

  User(this.phoneNumber, this.displayName, this.status);

  get contacts => UnmodifiableListView(_contacts);

  addContact(Contact contact) => _contacts.add(contact);
}
