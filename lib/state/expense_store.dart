import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/expense.dart';

class ExpenseStore extends ChangeNotifier {
  ExpenseStore._();
  static final ExpenseStore instance = ExpenseStore._();

  final _db = DatabaseHelper.instance;
  List<Expense> items = [];
  bool loading = true;
  String? error;

  double get totalIncome =>
      items.where((e) => !e.isExpense).fold(0.0, (s, e) => s + e.amount);
  double get totalExpense =>
      items.where((e) => e.isExpense).fold(0.0, (s, e) => s + e.amount);
  double get balance => totalIncome - totalExpense;

  double get dailyAverage {
    final exp = items.where((e) => e.isExpense).toList();
    if (exp.isEmpty) return 0;
    final days =
        exp.map((e) => DateTime(e.date.year, e.date.month, e.date.day)).toSet();
    return totalExpense / days.length;
  }

  double get weeklyExpense {
    final from = DateTime.now().subtract(const Duration(days: 7));
    return items
        .where((e) => e.isExpense && e.date.isAfter(from))
        .fold(0.0, (s, e) => s + e.amount);
  }

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      error = null;
      await load();
      return true;
    } catch (e) {
      error = 'Database error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> load() async {
    try {
      items = await _db.getAll();
      error = null;
    } catch (e) {
      error = 'Could not load data: $e';
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> add(Expense e) => _run(() => _db.insert(e));
  Future<bool> update(Expense e) => _run(() => _db.update(e));
  Future<bool> delete(int id) => _run(() => _db.delete(id));
}
