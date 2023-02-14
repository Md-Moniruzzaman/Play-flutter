import 'package:isar/isar.dart';
import 'package:isar_db_tutorial/entities/course.dart';
import 'package:isar_db_tutorial/entities/student.dart';
import 'package:isar_db_tutorial/entities/teacher.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveCourse(Course newCourse) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.courses.putSync(newCourse));
  }

  Future<void> saveStudent(Student newStudent) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.students.putSync(newStudent));
  }

  Future<void> saveTeacher(Teacher newTeacher) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.teachers.putSync(newTeacher));
  }

  Future<List<Course>> getAllCourses() async {
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    final isar = await db;
    yield* isar.courses.where().watch(initialReturn: true);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<Student>> getStudentsFor(Course course) async {
    final isar = await db;
    return await isar.students
        .filter()
        .courses((q) => q.idEqualTo(course.id))
        .findAll();
  }

  Future<Teacher?> getTeacherFor(Course course) async {
    final isar = await db;

    final teacher = await isar.teachers
        .filter()
        .course((q) => q.idEqualTo(course.id))
        .findFirst();

    return teacher;
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [CourseSchema, StudentSchema, TeacherSchema],
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
