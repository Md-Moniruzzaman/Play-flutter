import 'package:flutter/material.dart';
import 'package:sqflite_cipher/database/database_services.dart';
import 'package:sqflite_cipher/model/student_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();

  bool _isupdate = false;
  bool selected = true;
  int? selectedId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SqfLite Cipher'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FutureBuilder(
                future: DatabaseServices().getStudents(),
                builder: (context, AsyncSnapshot<List<Student>> snapshpot) {
                  if (!snapshpot.hasData) {
                    return const Center(child: Text('Loading.....'));
                  }

                  return snapshpot.data!.isNotEmpty
                      ? ListView(
                          children: snapshpot.data!
                              .map((e) => InkWell(
                                    onDoubleTap: () {
                                      _nameController.clear();
                                      selectedId = null;
                                      setState(() {});
                                    },
                                    child: Card(
                                      color: selectedId == e.id!
                                          ? Colors.grey
                                          : Colors.white,
                                      child: ListTile(
                                          title: Text(e.name),
                                          // subtitle: Text(e.roll.toString()),
                                          onLongPress: () {
                                            DatabaseServices()
                                                .removeStudent(e.id!);
                                            setState(() {});
                                          },
                                          onTap: () {
                                            if (selectedId == null) {
                                              _nameController.text = e.name;
                                              setState(() {
                                                _isupdate = true;
                                                selectedId = e.id!;
                                              });
                                            } else {
                                              selected = !selected;
                                              _nameController.text = e.name;
                                              selectedId = e.id;
                                              setState(() {});
                                            }
                                          }),
                                    ),
                                  ))
                              .toList(),
                        )
                      : const Center(child: Text('Student list is empty!'));
                }),
            Align(
              alignment: Alignment.bottomCenter,

              ///Your TextBox Container
              child: Card(
                color: Colors.blueGrey,
                elevation: 5,
                child: Container(
                  // color:
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // First child is enter comment text input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nameController,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: "Some Text",
                              labelStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              fillColor: Colors.blue,
                              border: OutlineInputBorder(
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.zero(5.0)),
                                  borderSide:
                                      BorderSide(color: Colors.purpleAccent)),
                            ),
                          ),
                        ),
                      ),
                      // Second child is button
                      IconButton(
                        icon: const Icon(Icons.send),
                        iconSize: 20.0,
                        onPressed: () async {
                          Student student =
                              Student(name: _nameController.text, roll: 1);
                          if (selectedId != null) {
                            _onPressedSend(student, selectedId!);
                          } else {
                            _onPressedSend(student, selectedId ?? -1);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _onPressedSend(Student student, int sId) async {
    if (_isupdate) {
      await DatabaseServices()
          .updateStudent(Student(id: sId, name: _nameController.text, roll: 3));
      setState(() {
        _nameController.clear();
      });
    } else {
      await DatabaseServices().addStudent(student);
      setState(() {
        _nameController.clear();
      });
    }
  }
}
