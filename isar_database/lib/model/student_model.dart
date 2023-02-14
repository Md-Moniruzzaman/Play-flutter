import 'package:isar/isar.dart';
import 'package:isar_database/model/course_model.dart';

part 'student_model.g.dart';

@Collection()
class Student {
  Id id = Isar.autoIncrement;
  late String name;
  final courses = IsarLinks<Course>();
}
