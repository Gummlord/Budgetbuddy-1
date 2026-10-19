/// A single money movement. [type] is either 'expense' or 'income'.
class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime date;
  final String notes;
  final String? receiptUrl;
  final DateTime? createdAt;
  final String type;

  const Expense({
    this.id = '',
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.notes = '',
    this.receiptUrl,
    this.createdAt,
    this.type = 'expense',
  });

  bool get isIncome => type == 'income';

  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      name: '${map['name'] ?? ''}',
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0,
      category: '${map['category'] ?? 'Other'}',
      date: DateTime.tryParse('${map['date'] ?? ''}') ?? DateTime.now(),
      notes: '${map['notes'] ?? ''}',
      receiptUrl: map['receiptUrl'] as String?,
      createdAt: DateTime.tryParse('${map['createdAt'] ?? ''}'),
      type: map['type'] == 'income' ? 'income' : 'expense',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'notes': notes,
    'receiptUrl': receiptUrl,
    'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    'type': type,
  };
}
