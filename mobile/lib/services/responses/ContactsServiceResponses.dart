import 'package:mobile/domain/Contact.dart';

class AddContactResponse {
  final AddContactResponseStatus status;
  final Contact? contact;

  AddContactResponse(this.status, this.contact);
}

enum AddContactResponseStatus { SUCCESS, DUPLICATE_NUMBER, GENERAL_ERROR }
