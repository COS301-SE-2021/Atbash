import 'Chat.dart';

class Contact {
  final String phoneNumber;
  String displayName;
  String status;

  Chat? chat;

  Contact(this.phoneNumber, this.displayName, this.status);
}
