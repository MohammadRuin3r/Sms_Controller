import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'users';
final String columnId = 'id';
final String columnPhone = 'phone';

class SystemUserController {
  final int id;
  final String phone;
  SystemUserController({this.id, this.phone});

  Map<String, dynamic> toMap() {
    return {columnId: this.id, columnPhone: this.phone};
  }
}

class SystemUserHelper {
  Database db;

  SystemUserHelper() {
    createDatabase();
  }

  // Create Database
  Future<void> createDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'Users.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnPhone TEXT)');
      },
      version: 1,
    );
  }

  // Insert Data into Database
  Future<void> setUsers(SystemUserController model) async {
    try {
      db.insert(
        tableName,
        model.toMap(),
      );
    } catch (e) {
      print(e);
    }
  }

  // Get Data From Database
  Future<List<SystemUserController>> getUsers() async {
    final List<Map<String, dynamic>> task = await db.query(tableName);

    return List.generate(task.length, (index) {
      return SystemUserController(
          id: task[index][columnId], phone: task[index][columnPhone]);
    });
  }
  void deleteDB() async{
db.delete(tableName);
print('Deleted');
  }
}

