import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

const dataBaseName = 'myDatabase';
const folderName = 'student_5';
const tableName = 'studentTable';

class DataBaseHelper2 {
  DataBaseHelper2._privateConstractor();
  static final DataBaseHelper2 instance = DataBaseHelper2._privateConstractor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDatabase();

  Future initDatabase() async {
    late Database db;
    // Directory directory = Directory(path)
    // List<Directory>? documentDirectory = await getExternalStorageDirectories();
    // Directory documentDirectory = await getTemporaryDirectory();
    // documentDirectory!.forEach((element) {
    //   print(element);
    // });
    // String path = join(documentDirectory.path, 'myfile');
    Directory dir = Directory('/storage/emulated/0/Download/sql_db_folder2');
    await _createFolder(dir);
    db = await openDatabase(
      '${dir.path}/$folderName.db',
      password: '12345',
      version: 3,
      onCreate: _createDatabaseTable,
    );
    // print(dir.path);
    // print(documentDirectory.path);
    return db;
  }

  Future _createDatabaseTable(db, version) async {
    String table = '''CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY,
      name TEXT,
      roll INTEGER
    )''';

    print(table.toString());

    await db.execute(table);
  }

  Future _createFolder(Directory? dir) async {
    if (!await Permission.storage.status.isGranted) {
      await Permission.storage.request();
    }

    if (await dir!.exists()) {
      return;
    } else {
      dir.create();
    }
  }
}
