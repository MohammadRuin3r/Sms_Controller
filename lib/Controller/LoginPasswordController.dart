import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'loginPassword';
final String columnId = 'id';
final String columnPassword = 'password';

class LoginPasswordController {
  final String password;
  final int id;

  LoginPasswordController({this.id = 1, this.password});

  Map<String, dynamic> toMap() {
    return {columnId: this.id, columnPassword: this.password};
  }
}

class LoginPasswordHelper {
  Database db;

  LoginPasswordHelper() {
    createDatabase();
  }

  // Create Database
  Future<void> createDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'LoginPassword.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY , $columnPassword TEXT)');
      },
      version: 1,
    );
  }

  // Insert Data into Database
  Future<void> setPassword(LoginPasswordController model) async {
    try {
      db.insert(tableName, model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  // Get Data From Database
  Future<List<LoginPasswordController>> getPassword() async {
    final List<Map<String, dynamic>> task = await db.query(tableName);

    return List.generate(task.length, (index) {
      return LoginPasswordController(
          id: task[index][columnId], password: task[index][columnPassword]);
    });
  }


}

