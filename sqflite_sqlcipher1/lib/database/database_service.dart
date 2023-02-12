import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher1/database/database_helper.dart';
import 'package:sqflite_sqlcipher1/model_class.dart';

class SqliteService {
  addStudent(StudentModel studentModel) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''INSERT INTO ${SqliteHelper.tableStudent} VALUES (
      '${studentModel.name}', 
      ${studentModel.roll}, 
      ${studentModel.isMale}, 
      ${studentModel.result})''';
    // print(query);
    var v = await db.rawInsert(query);
    print(v);
  }

  getStudent(int roll) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''SELECT * FROM ${SqliteHelper.tableStudent}
    WHERE ${SqliteHelper.studentRoll}=$roll''';
    // print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
  }

  getAllStudent() async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''SELECT * FROM ${SqliteHelper.tableStudent}''';
    // print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
  }

  updateStudent(int roll, StudentModel studentModel) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''UPDATE ${SqliteHelper.tableStudent} SET 
    ${SqliteHelper.studentName} =  '${studentModel.name}',
    ${SqliteHelper.studentRoll} =  ${studentModel.roll},
    ${SqliteHelper.studentIsMale} =  ${studentModel.isMale},
    ${SqliteHelper.studentResult} =  ${studentModel.result}
    WHERE ${SqliteHelper.studentRoll}=$roll
    ''';
    // print(query);
    var v = await db.rawQuery(query);
    print(v.toString());
  }

  deleteStudent(int roll) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''DELETE FROM ${SqliteHelper.tableStudent}
    WHERE ${SqliteHelper.studentRoll}=$roll''';
    // print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
  }

  deleteAllStudent() async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''DELETE FROM ${SqliteHelper.tableStudent}''';
    // print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
  }
}
