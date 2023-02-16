import 'dart:io';

import 'package:isar/isar.dart';
import 'package:isar_database/model/course_model.dart';
import 'package:isar_database/model/student_model.dart';
import 'package:isar_database/model/teacher_model.dart';

class IsarServices {
  late Future<Isar> db;
  IsarServices() {
    db = openDb();
  }

  Future<void> saveCourse(Course newCourse) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.courses.putSync(newCourse));
  }

  Future<void> saveTeacher(Teacher newTeacher) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.teachers.putSync(newTeacher));
  }

  Future<void> saveStudent(Student newStudent) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.students.putSync(newStudent));
  }

  Future<List<Course>> getAllCourses() async {
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    final isar = await db;
    yield* isar.courses.where().watch(fireImmediately: false);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([TeacherSchema, StudentSchema, CourseSchema],
          inspector: true,
          directory:
              Directory('/storage/emulated/0/Download/sql_db_folder2/isardb')
                  .path);
    }

    return Future.value(Isar.getInstance());
  }
}
