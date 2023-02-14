import 'package:flutter/material.dart';
import 'package:isar_db_tutorial/entities/course.dart';
import 'package:isar_db_tutorial/entities/teacher.dart';
import 'package:isar_db_tutorial/isar_service.dart';

class TeacherModal extends StatefulWidget {
  final IsarService service;

  const TeacherModal(this.service, {Key? key}) : super(key: key);

  @override
  State<TeacherModal> createState() => _TeacherModalState();
}

class _TeacherModalState extends State<TeacherModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  Course? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Give your new teacher a name",
                style: Theme.of(context).textTheme.headlineSmall),
            TextFormField(
              controller: _textController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Teacher Name is not allowed to be empty";
                return null;
              },
            ),
            FutureBuilder<List<Course>>(
              future: widget.service.getAllCourses(),
              builder: (context, AsyncSnapshot<List<Course>> snapshot) {
                if (snapshot.hasData) {
                  List<Course> data = snapshot.data!;
                  selectedCourse = data.first;
                  final courses = data.map((course) {
                    return DropdownMenuItem<Course>(
                        value: course, child: Text(course.title));
                  }).toList();

                  return DropdownButtonFormField<Course>(
                      items: courses,
                      value: selectedCourse,
                      onChanged: (course) => selectedCourse = course);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(selectedCourse!.id);
                    widget.service.saveTeacher(
                      Teacher()
                        ..name = _textController.text
                        ..course.value = selectedCourse,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "New teacher '${_textController.text}' saved in DB")));

                    Navigator.pop(context);
                  }
                },
                child: const Text("Add new teacher"))
          ],
        ),
      ),
    );
  }
}
