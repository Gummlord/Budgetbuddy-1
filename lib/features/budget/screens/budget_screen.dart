import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/budget_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_input_field.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BudgetProvider>();
    final b = p.budget;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Budget'),
      ),
      body: p.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 170),
              children: [
                BudgetCard(
                  period: 'DAILY',
                  budget: b.daily,
                  spent: p.spentDaily,
                  onEdit: () => _openSheet(context),
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'WEEKLY',
                  budget: b.weekly,
                  spent: p.spentWeekly,
                  onEdit: () => _openSheet(context),
                ),
                const SizedBox(height: 14),
                BudgetCard(
                  period: 'MONTHLY',
                  budget: b.monthly,
                  spent: p.spentMonthly,
                  onEdit: () => _openSheet(context),
                ),
                if (p.error != null) ...[
                  const SizedBox(height: 14),
                  Text(p.error!,
                      style:
                          AppTextStyles.text.copyWith(color: c.error)),
                ],
              ],
            ),
    );
  }

  void _openSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.all(24),
        child: _BudgetSheet(periods: ['daily', 'weekly', 'monthly']),
      ),
    );
  }
}

class _BudgetSheet extends StatefulWidget {
  final List<String> periods; // 'daily', 'weekly', 'monthly'
  const _BudgetSheet({required this.periods});

  @override
  State<_BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends State<_BudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;

  static const _labels = {
    'daily': 'Daily budget',
    'weekly': 'Weekly budget',
    'monthly': 'Monthly budget',
  };
  static const _icons = {
    'daily': Icons.today_rounded,
    'weekly': Icons.date_range_rounded,
    'monthly': Icons.calendar_month_rounded,
  };

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  void initState() {
    super.initState();
    final b = context.read<BudgetProvider>().budget;
    double current(String k) =>
        k == 'daily' ? b.daily : (k == 'weekly' ? b.weekly : b.monthly);
    _c = {
      for (final k in widget.periods)
        k: TextEditingController(text: current(k) == 0 ? '' : _fmt(current(k))),
    };
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    double? v(String k) =>
        _c[k] == null ? null : double.parse(_c[k]!.text.trim());

    final ok = await context.read<BudgetProvider>().save(
          daily: v('daily'),
          weekly: v('weekly'),
          monthly: v('monthly'),
        );
    if (!mounted) return;
    if (ok) {
      nav.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Budget saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<BudgetProvider>().isSaving;
    final c = context.colors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.periods.length == 1 ? 'Edit budget' : 'Set your budgets',
              style: AppTextStyles.subHeader.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            for (final k in widget.periods) ...[
              BudgetInputField(
                controller: _c[k]!,
                label: _labels[k]!,
                icon: _icons[k]!,
                textInputAction: k == widget.periods.last
                    ? TextInputAction.done
                    : TextInputAction.next,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary,
                  foregroundColor: c.onPrimary,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  textStyle:
                      AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                ),
                child: saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: c.onPrimary),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
