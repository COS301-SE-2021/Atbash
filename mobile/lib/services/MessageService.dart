import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/DatabaseService.dart';

class MessageService {
  final DatabaseService databaseService;

  MessageService(this.databaseService);

  Future<List<Message>> fetchAllBySenderOrRecipient(String phoneNumber) {
    throw UnimplementedError();
  }

  Future<Message> save(Message message) {
    throw UnimplementedError();
  }

  Future<void> deleteById(String id) {
    throw UnimplementedError();
  }
}
