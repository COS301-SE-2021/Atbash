import 'package:mobile/domain/Chat.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChatService {
  final DatabaseService databaseService;

  ChatService(this.databaseService);

  Future<List<Chat>> fetchAll() {
    throw UnimplementedError();
  }

  Future<Chat> save(Chat chat) {
    throw UnimplementedError();
  }

  Future<void> deleteById(String id) {
    throw UnimplementedError();
  }
}
