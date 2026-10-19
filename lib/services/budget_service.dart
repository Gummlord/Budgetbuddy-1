import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget.dart';

/// Persists a user's budget locally. (Future step: move to Firestore.)
class BudgetService {
  String _key(String uid) => 'budget_$uid';

  Future<Budget> getBudget(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key(uid));
    if (text == null) return const Budget();
    return Budget.fromMap(jsonDecode(text) as Map<String, dynamic>);
  }

  Future<void> saveBudget(String uid, Budget budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid), jsonEncode(budget.toMap()));
  }
}
