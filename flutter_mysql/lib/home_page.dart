import 'package:flutter/material.dart';
import 'package:flutter_mysql/services/mysql_services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MysqlService _mysqlService = MysqlService();
  final _nameCtrl = TextEditingController();
  final _employeeIdCtrl = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _selected = false;
  bool isSelected = false;
  bool _isUpdate = false;
  int? _selectedId;

  @override
  void dispose() {
    _employeeIdCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Mysql Connection'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              TextFormField(
                                autofocus: true,
                                controller: _employeeIdCtrl,
                                decoration: const InputDecoration(
                                    labelText: 'Eployee Id',
                                    border: OutlineInputBorder()),
                                // validator: (value) {
                                //   if (value == '' || value == null) {
                                //     return 'Id must needed';
                                //   } else {
                                //     return '';
                                //   }
                                // },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                autofocus: true,
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                    labelText: 'Eployee name',
                                    border: OutlineInputBorder()),
                                // validator: (value) {
                                //   if (value == '' || value == null) {
                                //     return 'Name must needed';
                                //   } else {
                                //     return '';
                                //   }
                                // },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _isUpdate = false;
                                        _employeeIdCtrl.clear();
                                        _nameCtrl.clear();
                                      },
                                      child: const Text('Cancel')),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _formkey.currentState!.save();
                                        if (_isUpdate && _selectedId != null) {
                                          _mysqlService.updateEmployee(
                                              _employeeIdCtrl.text,
                                              _nameCtrl.text,
                                              _selectedId!);
                                          _isUpdate = false;
                                        } else {
                                          _mysqlService.insertEmploy(
                                              _employeeIdCtrl.text,
                                              _nameCtrl.text);
                                        }

                                        setState(() {
                                          _employeeIdCtrl.clear();
                                          _nameCtrl.clear();
                                        });
                                      },
                                      child: const Text('Save'))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            const VerticalDivider(
              color: Colors.blueGrey,
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder(
                future: _mysqlService.getEmployee(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    List data = snapshot.data!;

                    // print(data);
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            // color:
                            //     _selected ? Colors.greenAccent : Colors.white,
                            child: ListTile(
                              selectedTileColor:
                                  _selected ? Colors.greenAccent : Colors.white,
                              title: Text(data[index]['emName'].toString()),
                              subtitle: Text(data[index]['emId'].toString()),
                              trailing: SizedBox(
                                width: 80,
                                child: Row(
                                  children: [
                                    IconButton(
                                      isSelected: isSelected,
                                      onPressed: () {
                                        _employeeIdCtrl.text =
                                            data[index]['emId'].toString();
                                        _nameCtrl.text =
                                            data[index]['emName'].toString();
                                        setState(() {
                                          _selectedId = data[index]['id'];
                                          _isUpdate = true;
                                          _selected = true;
                                          isSelected = !isSelected;
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _mysqlService
                                            .deleteEmployee(data[index]['id']);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return const Text('');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
