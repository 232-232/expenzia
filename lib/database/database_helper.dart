import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _table = 'expenses';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'expenzia.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE $_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          description TEXT
        )
      '''),
    );
  }

  Future<int> insert(Expense e) async =>
      (await _database).insert(_table, e.toMap());

  Future<List<Expense>> getAll() async {
    final rows = await (await _database).query(_table, orderBy: 'date DESC, id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> update(Expense e) async => (await _database)
      .update(_table, e.toMap(), where: 'id = ?', whereArgs: [e.id]);

  Future<int> delete(int id) async =>
      (await _database).delete(_table, where: 'id = ?', whereArgs: [id]);
}
