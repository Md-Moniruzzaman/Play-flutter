import 'package:flutter/material.dart';
import 'package:isar_database/model/course_model.dart';
import 'package:isar_database/services/isar_services.dart';

class AddStudent extends StatefulWidget {
  final IsarServices isarServices;
  const AddStudent(this.isarServices, {super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _nameCtrl = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<Course> allCourses = [];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Text(
              'Given your new student name:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ));
  }
}
