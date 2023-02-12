import 'package:sqflite_cipher/database/database_helper.dart';
import 'package:sqflite_cipher/model/student_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseServices {
  Future<List<Student>> getStudents() async {
    List<Student> studentList = [];
    Database db = await DataBaseHelper2.instance.database;

    List students = await db.query(tableName, orderBy: 'name');

    studentList = students.isNotEmpty
        ? students.map((e) => Student.fromMap(e)).toList()
        : [];
    return studentList;
  }

  Future<int> addStudent(Student student) async {
    Database db = await DataBaseHelper2.instance.database;

    return await db.insert(tableName, student.toMap());
  }

  Future<int> updateStudent(Student student) async {
    Database db = await DataBaseHelper2.instance.database;

    return await db.update(tableName, student.toMap(),
        where: 'id = ?', whereArgs: [student.id]);
  }

  Future<int> removeStudent(int id) async {
    Database db = await DataBaseHelper2.instance.database;

    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
