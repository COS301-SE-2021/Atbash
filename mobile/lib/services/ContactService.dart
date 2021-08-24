import 'package:mobile/domain/Contact.dart';
import 'package:mobile/services/DatabaseService.dart';

class ContactService {
  final DatabaseService databaseService;

  ContactService(this.databaseService);

  Future<List<Contact>> fetchAll() {
    throw UnimplementedError();
  }

  Future<Contact> save(Contact contact) {
    throw UnimplementedError();
  }

  Future<void> deleteByPhoneNumber(String phoneNumber) {
    throw UnimplementedError();
  }
}
