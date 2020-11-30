import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'system_status';
final String columnId = 'id';
final String columnSystemState = 'status';

class SystemStatusController {
  final String status;
  final int id;

  SystemStatusController({this.id = 1, this.status});

  Map<String, dynamic> toMap() {
    return {columnId: this.id, columnSystemState: this.status};
  }
}

class SystemStatusHelper {
  Database db;

  SystemStatusHelper() {
    createDatabase();
  }

  // Create Database
  Future<void> createDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'SystemStatus.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnSystemState TEXT)');
      },
      version: 1,
    );
  }

  // Insert Data into Database
  Future<void> setStatus(SystemStatusController model) async {
    try {
      db.insert(tableName, model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  // Get Data From Database
  Future<List<SystemStatusController>> getStatus() async {
    final List<Map<String, dynamic>> task = await db.query(tableName);

    return List.generate(task.length, (index) {
      return SystemStatusController(
          id: task[index][columnId], status: task[index][columnSystemState]);
    });
  }

  void deleteDB() async {
    db.delete(tableName);
    print('Deleted');
  }
}
