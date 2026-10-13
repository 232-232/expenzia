class Expense {
  final int? id;
  final String type;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;

  const Expense({
    this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
  });

  bool get isExpense => type == 'Expense';

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'description': description,
      };

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        type: m['type'] as String,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        category: m['category'] as String,
        date: DateTime.parse(m['date'] as String),
        description: (m['description'] as String?) ?? '',
      );
}
