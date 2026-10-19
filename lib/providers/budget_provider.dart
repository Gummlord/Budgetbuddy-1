import 'package:flutter/foundation.dart';
import '../models/budget.dart';
import '../services/budget_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetService _service;
  BudgetProvider({BudgetService? service})
      : _service = service ?? BudgetService();

  String? _uid;
  Budget _budget = const Budget();
  bool _loading = false;
  bool _saving = false;
  String? _error;

  double spentDaily = 0;
  double spentWeekly = 0;
  double spentMonthly = 0;

  Budget get budget => _budget;
  bool get isLoading => _loading;
  bool get isSaving => _saving;
  String? get error => _error;

  void updateSpent({double? daily, double? weekly, double? monthly}) {
    spentDaily = daily ?? spentDaily;
    spentWeekly = weekly ?? spentWeekly;
    spentMonthly = monthly ?? spentMonthly;
    notifyListeners();
  }

  Future<void> start(String? uid) async {
    if (uid == _uid) return;
    _uid = uid;
    _budget = const Budget();
    _error = null;
    if (uid == null) {
      _loading = false;
      Future.microtask(notifyListeners);
      return;
    }
    _loading = true;
    try {
      _budget = await _service.getBudget(uid);
    } catch (_) {
      _error = 'Could not load your budget.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> save({double? daily, double? weekly, double? monthly}) async {
    final uid = _uid;
    if (uid == null) {
      _error = 'Please log in again.';
      notifyListeners();
      return false;
    }
    _saving = true;
    _error = null;
    notifyListeners();
    try {
      final newBudget = Budget(
        daily: daily ?? _budget.daily,
        weekly: weekly ?? _budget.weekly,
        monthly: monthly ?? _budget.monthly,
        updatedAt: DateTime.now(),
      );
      await _service.saveBudget(uid, newBudget);
      _budget = newBudget;
      return true;
    } catch (_) {
      _error = 'Could not save your budget. Please try again.';
      return false;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
