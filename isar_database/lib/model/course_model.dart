import 'package:isar/isar.dart';
import 'package:isar_database/model/student_model.dart';
import 'package:isar_database/model/teacher_model.dart';

part 'course_model.g.dart';

@Collection()
class Course {
  Id id = Isar.autoIncrement;
  late String title;

  @Backlink(to: 'course')
  final teacher = IsarLink<Teacher>();

  @Backlink(to: 'courses')
  final students = IsarLinks<Student>();
}
