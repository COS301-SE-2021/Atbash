import 'package:mobile/domain/Child.dart';
import 'package:mobile/services/DatabaseService.dart';

class ChildrenService {
  final DatabaseService databaseService;

  ChildrenService(this.databaseService);

  Future<List<Child>> fetchAll() async {
    final db = await databaseService.database;

    final response = await db.query(Child.TABLE_NAME, orderBy: "name");

    final children = <Child>[];
    response.forEach((element) {
      final child = Child.fromMap(element);

      if (child != null) children.add(child);
    });

    return children;
  }

  Future<Child> fetchByPhoneNumber(String phoneNumber) async {
    final db = await databaseService.database;

    final response = await db.query(Child.TABLE_NAME,
        where: "${Child.COLUMN_PHONE_NUMBER} = ?", whereArgs: [phoneNumber]);

    if (response.isEmpty) throw ChildDoesNotExistException();

    final child = Child.fromMap(response.first);
    if (child == null) {
      throw ChildDoesNotExistException();
    } else {
      return child;
    }
  }


}

class ChildDoesNotExistException implements Exception {}
