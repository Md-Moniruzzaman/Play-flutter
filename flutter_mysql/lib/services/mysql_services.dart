import 'package:mysql1/mysql1.dart';

class MysqlService {
  late Future<MySqlConnection> conn;
  MysqlService() {
    conn = openDb();
  }

  Future<Results> insertEmploy(String emId, String emName) async {
    return await conn.then((value) => value.query(
        'insert into employee (emId, emName, password) values (?, ?, ?)',
        [emId, emName, '1234']));
  }

  Future<List> getEmployee() async {
    List data = [];
    await conn.then((value) =>
        value.query('SELECT * FROM `employee` ORDER BY emName').then((results) {
          for (var row in results) {
            Map map = {'id': row[0], 'emId': row[1], 'emName': row[2]};
            data.add(map);
          }
        }));
    return data;
  }

  Future updateEmployee(String emId, String emName, int id) async {
    await conn.then((value) => value.query(
        "UPDATE employee SET emName = '$emName', emId= '$emId' WHERE id = $id"));
  }

  Future deleteEmployee(int id) async {
    await conn
        .then((value) => value.query('DELETE FROM employee WHERE id = $id'));
  }

  Future<MySqlConnection> openDb() async {
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      // password: '1234',
      db: 'mydb',
    );

    return await MySqlConnection.connect(settings);
  }
}
