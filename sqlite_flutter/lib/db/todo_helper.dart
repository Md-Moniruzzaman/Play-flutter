import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';
final String columnId = 'id';
final String columnName = 'name';
final String columnAge = 'age';

class Todo {
  int? id;
  String name = '';
  bool age = false;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{columnName: name, columnAge: age};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    age = map[columnAge];
  }
}

class TodoProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnAge integer not null)
''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo?> getTodo(int id) async {
    List<Map> maps =
        await db.query(tableTodo, columns: [columnId, columnAge, columnName], where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(), where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
