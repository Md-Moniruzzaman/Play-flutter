import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqliteHelper {
  //#####student table
  static const String tableStudent = 'studentTable';
  //student column
  static const String studentName = 'name';
  static const String studentRoll = 'roll';
  static const String studentIsMale = 'isMale';
  static const String studentResult = 'result';

  //----------------------- DB Access
  static Database? _database;

  // static final SqliteHelper instance = SqliteHelper._init();
  // SqliteHelper._init();

  Future<Database> get databaseGet async {
    if (_database != null) {
      return _database!;
    } else {
      print('#####Initial Sql');
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<void> openSqlDatabase() async {
    if (!_database!.isOpen) {
      _database = await _initDatabase();
    }
  }

  Future<void> closeSqlDatabase() async {
    if (_database!.isOpen) {
      print('#####Close Sql');
      _database!.close();
    }
  }

  Future<void> checkDatabase() async {
    print(await _database!.isOpen);
  }

  //show table
  Future<void> showTablesInDatabase() async {
    String query = '''SELECT name FROM sqlite_master WHERE type=\'table\'''';
    // print(query.toString());
    print(await _database!.rawQuery(query));
  }

  Future<void> dropTableInDatabase() async {
    String query = '''DROP TABLE ${SqliteHelper.tableStudent}''';
    // print(query.toString());
    print(await _database!.rawQuery(query));
  }

  //----------------------- DB Unauthorize
  Future<Database> _initDatabase() async {
    late Database db;
    Directory databaseDir =
        Directory('/storage/emulated/0/Download/sql_db_folder');

    await _createFolder(databaseDir);

    if (await databaseDir.exists()) {
      print('#####Create DB / OpenDB');
      db = await openDatabase(
        '${databaseDir.path}/mydatabase.db',
        password: '1234',
        version: 3,
        onCreate: _createTableWithDatabase,
      );
    }
    return db;
  }

  Future<void> _createFolder(Directory dir) async {
    if (!await Permission.storage.status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
    } else {
      dir.create();

      print('#####Create Folder');
    }
  }

  void _createTableWithDatabase(db, version) async {
    print('#####Create Table');
    String query = '''CREATE TABLE $tableStudent (
          $studentName TEXT,
          $studentRoll INTEGER,
          $studentIsMale BOOL,
          $studentResult DOUBLE)''';
    print(query.toString());
    await db.execute(query);
  }
}
