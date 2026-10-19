import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/category_chip.dart';
import '../widgets/expense_tile.dart';
import 'edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String? _selected;

  void _confirmDelete(BuildContext context, Expense e) {
    final c = context.colors;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete this entry?',
          style: AppTextStyles.title.copyWith(
            color: c.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This item will be removed from your list.',
          style: AppTextStyles.text.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.text.copyWith(
                color: c.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ExpenseProvider>().delete(e);
            },
            child: Text(
              'Delete',
              style: AppTextStyles.text.copyWith(
                color: c.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final c = context.colors;
    final filtered = _selected == null
        ? p.expenses
        : p.expenses.where((e) => e.category == _selected).toList();

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Expenses'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: CategoryChipRow(
                selected: _selected,
                includeAll: true,
                onSelected: (c) => setState(() => _selected = c),
              ),
            ),
            Expanded(
              child: p.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            p.error ??
                                (_selected == null
                                    ? 'No expenses yet'
                                    : 'No expenses in this category'),
                            style: AppTextStyles.title
                                .copyWith(color: c.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final e = filtered[i];
                            return ExpenseTile(
                              expense: e,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        EditExpenseScreen(expense: e)),
                              ),
                              onDelete: () => _confirmDelete(context, e),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
