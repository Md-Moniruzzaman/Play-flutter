import 'package:isar/isar.dart';
import 'package:isar_database/model/course_model.dart';

part 'teacher_model.g.dart';

@Collection()
class Teacher {
  Id id = Isar.autoIncrement;
  late String name;
  late String roll;
  final course = IsarLink<Course>();
}
