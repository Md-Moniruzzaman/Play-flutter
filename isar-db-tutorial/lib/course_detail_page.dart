import 'package:flutter/material.dart';
import 'package:isar_db_tutorial/entities/course.dart';
import 'package:isar_db_tutorial/entities/student.dart';
import 'package:isar_db_tutorial/entities/teacher.dart';
import 'package:isar_db_tutorial/isar_service.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  final IsarService service;

  static void navigate(context, Course course, IsarService service) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CourseDetailPage(course: course, service: service);
    }));
  }

  const CourseDetailPage(
      {Key? key, required this.course, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Teacher?>(
              future: service.getTeacherFor(course),
              builder: (context, snapshot) {
                return Row(children: [
                  const Text("Teacher: "),
                  Text(snapshot.hasData
                      ? snapshot.data!.name
                      : "No teacher yet for this course.")
                ]);
              },
            ),
            const SizedBox(height: 8),
            const Text("Students:"),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: service.getStudentsFor(course),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  if (snapshot.hasData) {
                    final students = snapshot.data!;
                    if (students.isEmpty) {
                      return const Text("No students in this course");
                    }

                    List<Text> studentsWidget = [];

                    for (int i = 0; i < students.length; i++) {
                      final student = students[i];
                      studentsWidget.add(Text("$i. ${student.name}"));
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [...studentsWidget],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
