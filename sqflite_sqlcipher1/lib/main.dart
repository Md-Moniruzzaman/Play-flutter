import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher1/database/database_helper.dart';
import 'package:sqflite_sqlcipher1/database/database_service.dart';
import 'package:sqflite_sqlcipher1/model_class.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return HomePageState();
  }
}

class HomePageState extends State {
  List<StudentModel> stuList = [
    StudentModel(name: 'mahadi', roll: 35, isMale: true, result: 4.22),
    StudentModel(name: 'hassan', roll: 12, isMale: true, result: 3.52),
    StudentModel(name: 'mithun', roll: 17, isMale: true, result: 2.24),
    StudentModel(name: 'mr y', roll: 26, isMale: false, result: 3.48),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sqflite SqlCiphper')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await SqliteHelper().databaseGet;
                  },
                  child: const Text('init db')),
              ElevatedButton(
                  onPressed: () async {
                    await SqliteHelper().openSqlDatabase();
                  },
                  child: const Text('open db')),
              ElevatedButton(
                  onPressed: () {
                    SqliteHelper().closeSqlDatabase();
                  },
                  child: const Text('close db')),
              ElevatedButton(
                  onPressed: () {
                    SqliteHelper().checkDatabase();
                  },
                  child: const Text('check db isopen?')),
              ElevatedButton(
                  onPressed: () {
                    SqliteHelper().showTablesInDatabase();
                  },
                  child: const Text('show tables')),
              ElevatedButton(
                  onPressed: () {
                    SqliteHelper().dropTableInDatabase();
                  },
                  child: const Text('drop tables')),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    SqliteService().addStudent(stuList[0]);
                  },
                  child: const Text('add student 1')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().addStudent(stuList[2]);
                  },
                  child: const Text('add student 2')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().getStudent(35);
                  },
                  child: const Text('get')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().getAllStudent();
                  },
                  child: const Text('get all')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().updateStudent(35, stuList[1]);
                  },
                  child: const Text('update')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().deleteStudent(35);
                  },
                  child: const Text('delete')),
              ElevatedButton(
                  onPressed: () {
                    SqliteService().deleteAllStudent();
                  },
                  child: const Text('delete all')),
            ],
          ),
        ],
      ),
    );
  }
}
