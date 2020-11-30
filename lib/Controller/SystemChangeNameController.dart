import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'system_change_name';
final String columnId = 'id';
final String columnSystemChangeName = 'changename';

class SystemChaneNameController {
  final String name;
  final int id;

  SystemChaneNameController({this.id = 1, this.name});

  Map<String, dynamic> toMap() {
    return {columnId: this.id, columnSystemChangeName: this.name};
  }
}

class SystemChangeNameHelper {
  Database db;

  SystemChangeNameHelper() {
    createDatabase();
  }

  // Create Database
  Future<void> createDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'SystemChangeName.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnSystemChangeName TEXT)');
      },
      version: 1,
    );
  }

  // Insert Data into Database
  Future<void> setName(SystemChaneNameController model) async {
    try {
      db.insert(tableName, model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  // Get Data From Database
  Future<List<SystemChaneNameController>> getNames() async {
    final List<Map<String, dynamic>> task = await db.query(tableName);

    return List.generate(task.length, (index) {
      return SystemChaneNameController(
          id: task[index][columnId],
          name: task[index][columnSystemChangeName]);
    });
  }

  void deleteDB() async {
    db.delete(tableName);
    print('Deleted');
  }
}
