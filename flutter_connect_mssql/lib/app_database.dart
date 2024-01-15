// import 'package:moor/moor.dart';

// import 'package:moor_flutter/moor_flutter.dart';

// @DataClassName('YourModel')
// class AppDatabase extends _$AppDatabase {
//   AppDatabase(QueryExecutor e) : super(e);

//   // @override
//   int get schemaVersion => 1;

//   Table get yourTable => Table('Student', columns: [
//         intColumn('id').autoIncrement()(),
//         textColumn('name')(),
//         textColumn('description')(),
//       ]);

//   Future<List> getAllItems() => select(yourTable).get();
// }

// @UseMoor(tables: [YourTable])
// class _$AppDatabase extends _$QueryRowMixin with QueryRow {
//   _$AppDatabase(QueryExecutor e) : super(e);

//   @override
//   final List<TableInfo> allTables = [Student];

//   @override
//   final int version = 1;
// }
