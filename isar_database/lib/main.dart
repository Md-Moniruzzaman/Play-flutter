import 'package:flutter/material.dart';
import 'package:isar_database/pages/add_student.dart';
import 'package:isar_database/services/isar_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final IsarServices isarServices = IsarServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isar Database'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: isarServices.listenToCourses(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {}
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add Course'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddStudent(isarServices),
                  );
                },
                child: const Text('Add Student'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add Teacher'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }
}
