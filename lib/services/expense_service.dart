import 'dart:async';
import '../models/expense.dart';

/// In-memory expense store with a broadcast stream.
/// (Future step: back this with Firestore via DatabaseService.)
class ExpenseService {
  final List<Expense> _items = [
    Expense(
      id: '1',
      name: 'Siomai Rice/w Pastil',
      amount: 55,
      category: 'Food',
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      name: 'Allowance',
      amount: 1500,
      category: 'Other',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'income',
    ),
    Expense(
      id: '3',
      name: 'Jeepney fare',
      amount: 30,
      category: 'Transportation',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Expense(
      id: '4',
      name: 'Load',
      amount: 100,
      category: 'Load/Internet',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  final _controller = StreamController<List<Expense>>.broadcast();

  Stream<List<Expense>> watchExpenses(String uid) {
    Future.microtask(() => _controller.add(List<Expense>.from(_items)));
    return _controller.stream;
  }

  Future<void> add(String uid, Expense entry) async {
    final withId = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: entry.name,
      amount: entry.amount,
      category: entry.category,
      date: entry.date,
      notes: entry.notes,
      receiptUrl: entry.receiptUrl,
      createdAt: DateTime.now(),
      type: entry.type,
    );
    _items.add(withId);
    _controller.add(List<Expense>.from(_items));
  }

  Future<void> update(String uid, Expense entry) async {
    final index = _items.indexWhere((e) => e.id == entry.id);
    if (index == -1) return;
    _items[index] = entry;
    _controller.add(List<Expense>.from(_items));
  }

  Future<void> delete(String uid, String id) async {
    _items.removeWhere((e) => e.id == id);
    _controller.add(List<Expense>.from(_items));
  }

  void dispose() {
    _controller.close();
  }
}
