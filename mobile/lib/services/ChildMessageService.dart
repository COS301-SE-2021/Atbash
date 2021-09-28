import 'package:mobile/domain/ChildMessage.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildMessageService {
  final DatabaseService databaseService;

  ChildMessageService(this.databaseService);

  Future<List<ChildMessage>> fetchAllByChatId(String id) async {
    final db = await databaseService.database;

    final response = await db.query(ChildMessage.TABLE_NAME,
        where: "${ChildMessage.COLUMN_CHAT_ID} = ?", whereArgs: [id], orderBy: "${ChildMessage.COLUMN_TIMESTAMP} desc");

    final messages = <ChildMessage>[];
    response.forEach((element) {
      final message = ChildMessage.fromMap(element);

      if (message != null) messages.add(message);
    });

    return messages;
  }

  Future<void> insert(ChildMessage message) async{
    final db = await databaseService.database;

    await db.insert(ChildMessage.TABLE_NAME, message.toMap());
  }
  
  Future<void> deleteAllByChatId(String id) async{
    final db = await databaseService.database;
    
    await db.delete(ChildMessage.TABLE_NAME, where: "${ChildMessage.COLUMN_CHAT_ID} = ?", whereArgs: [id]);
  }
}
