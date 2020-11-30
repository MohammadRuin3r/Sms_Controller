import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'systemNumber';
final String columnId = 'id';
final String columnPhone = 'phone';

class SystemNumberController {
  final int id;
  final String phone;
  SystemNumberController({this.id = 1, this.phone});

  Map<String, dynamic> toMap() {
    return {columnId: this.id, columnPhone: this.phone};
  }
}

class SystemPhoneHelper {
  Database db;

  SystemPhoneHelper() {
    createDatabase();
  }

  // Create Database
  Future<void> createDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'SystemNumberDB.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnPhone TEXT)');
      },
      version: 1,
    );
  }

  // Insert Data into Database
  Future<void> setPhoneNumber(SystemNumberController model) async {
    try {
      db.insert(tableName, model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  // Get Data From Database
  Future<List<SystemNumberController>> getPhoneNumber() async {
    final List<Map<String, dynamic>> task = await db.query(tableName);

    return List.generate(task.length, (index) {
      return SystemNumberController(
          id: task[index][columnId], phone: task[index][columnPhone]);
    });
  }
}
