import 'package:mobile/domain/Contact.dart';

class CreateContactResponse {
  final CreateContactResponseStatus status;
  final Contact? contact;

  CreateContactResponse(this.status, this.contact);
}

enum CreateContactResponseStatus {
  SUCCESS,
  UPDATED,
  DUPLICATE_NUMBER,
  GENERAL_ERROR
}
