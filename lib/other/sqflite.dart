import 'package:sqflite/sqflite.dart';

Future<Database> openDB() async {
  return await openDatabase('db.db');
}

dynamic getToken() async {
  var data = await tableShow('personal_token');
  return data.isEmpty ? '' : data.first['token'];
}

Future<void> createTable(name, columns) async {
  var db = await openDB();

  List<dynamic> tables = await tableShow('sqlite_master', column: 'name');
  Iterable<dynamic> duplicate = tables.where((e) => e['name'] == name);
  if (duplicate.isEmpty) {
    String columnSql = '(';
    for (var key in columns.keys) {
      columnSql += ' $key ${columns[key]},';
    }
    columnSql = columnSql.substring(0, columnSql.length - 1);
    columnSql += ')';

    await db.execute('CREATE TABLE $name $columnSql');
    print('create table $name');
  } else {
    print('table $name already exists');
  }
}

Future<dynamic> tableTruncate(table) async {
  var db = await openDB();

  await db.rawQuery('DELETE FROM $table');
  print('clear data on table $table');
}

Future<dynamic> tableShow(table, {column = '*'}) async {
  var db = await openDB();

  var result = await db.rawQuery("SELECT $column FROM $table");

  print(result);
  return result;
}

Future<dynamic> tableWhere(
  table,
  column,
  value, {
  operator = '=',
  select = '*',
}) async {
  var db = await openDB();

  var result = await db
      .rawQuery("SELECT $select FROM $table WHERE $column$operator$value");

  print(result);
  return result;
}

Future<void> tableInsert(table, data) async {
  var db = await openDB();
  var column = '(';
  var quotes = '(';
  var values = [];

  for (var key in data.keys) {
    column += '$key,';
    quotes += '?,';
    values.add(data[key]);
  }

  column = '${column.substring(0, column.length - 1)})';
  quotes = '${quotes.substring(0, quotes.length - 1)})';

  await db.rawInsert('INSERT INTO $table$column VALUES$quotes', values);
  print('new data created on $table');
}
