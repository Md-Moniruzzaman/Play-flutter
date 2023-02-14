import 'package:isar/isar.dart';
import 'package:isar_db_tutorial/entities/student.dart';
import 'package:isar_db_tutorial/entities/teacher.dart';

part 'course.g.dart';

@Collection()
class Course {
  Id id = isarAutoIncrementId;
  late String title;

  @Backlink(to: "course")
  final teacher = IsarLink<Teacher>();

  @Backlink(to: "courses")
  final students = IsarLinks<Student>();
}
