import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../../utils/categories.dart';
import '../../budget/widgets/budget_input_field.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final String _category;
  late DateTime _date;

  bool get _isIncome => widget.expense.isIncome;

  Color _accent(BuildContext context) =>
      _isIncome ? context.colors.income : context.colors.expense;

  OutlineInputBorder _border(Color c, {double w = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _nameController = TextEditingController(text: e.name);
    _amountController = TextEditingController(
      text: e.amount == e.amount.roundToDouble()
          ? e.amount.toStringAsFixed(0)
          : e.amount.toStringAsFixed(2),
    );
    _category =
        Categories.all.contains(e.category) ? e.category : Categories.other;
    _date = e.date;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: AppTextStyles.title.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Save changes?',
          style: AppTextStyles.text.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.text.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Save',
              style: AppTextStyles.text.copyWith(
                color: _accent(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    final ok = await context.read<ExpenseProvider>().update(
          expense: widget.expense,
          name: _nameController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          category: _category,
          date: _date,
        );
    if (!mounted) return;
    if (ok) {
      nav.pop(true);
      messenger.showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<ExpenseProvider>().isLoading;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(_isIncome ? 'Edit income' : 'Edit expense'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              style: AppTextStyles.title.copyWith(color: colors.textPrimary),
              cursorColor: colors.textPrimary,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Name is required';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle:
                    AppTextStyles.text.copyWith(color: colors.textSecondary),
                floatingLabelStyle:
                    AppTextStyles.text.copyWith(color: colors.primary),
                prefixIcon:
                    Icon(Icons.label_rounded, color: colors.primary),
                filled: true,
                fillColor: colors.inputFill,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                errorStyle: AppTextStyles.text
                    .copyWith(color: colors.error, fontSize: 12),
                border: _border(Colors.transparent),
                enabledBorder: _border(Colors.transparent),
                focusedBorder: _border(colors.primary, w: 1.5),
                errorBorder: _border(colors.error),
                focusedErrorBorder: _border(colors.error, w: 1.5),
              ),
            ),
            const SizedBox(height: 12),
            BudgetInputField(
              controller: _amountController,
              label: 'Amount',
              icon: Icons.payments_rounded,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            Text(
              'Category',
              style: AppTextStyles.text.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded,
                  color: colors.primary),
              style: AppTextStyles.title.copyWith(color: colors.textPrimary),
              dropdownColor: colors.surface,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle:
                    AppTextStyles.text.copyWith(color: colors.textSecondary),
                floatingLabelStyle:
                    AppTextStyles.text.copyWith(color: colors.primary),
                prefixIcon:
                    Icon(Icons.category_rounded, color: colors.primary),
                filled: true,
                fillColor: colors.inputFill,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                errorStyle: AppTextStyles.text
                    .copyWith(color: colors.error, fontSize: 12),
                border: _border(Colors.transparent),
                enabledBorder: _border(Colors.transparent),
                focusedBorder: _border(colors.primary, w: 1.5),
                errorBorder: _border(colors.error),
                focusedErrorBorder: _border(colors.error, w: 1.5),
              ),
              items: [
                for (final c in Categories.all)
                  DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Icon(Categories.iconFor(c),
                            size: 20, color: colors.primary),
                        const SizedBox(width: 10),
                        Text(c),
                      ],
                    ),
                  ),
              ],
              onChanged: (c) => setState(() => _category = c ?? _category),
            ),
            const SizedBox(height: 16),
            Text(
              'Date',
              style: AppTextStyles.text.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: colors.inputFill,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDate,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: colors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _fmtDate(_date),
                        style: AppTextStyles.title
                            .copyWith(color: colors.textPrimary),
                      ),
                      const Spacer(),
                      Icon(Icons.edit_rounded,
                          size: 18, color: colors.primary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent(context),
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  textStyle: AppTextStyles.title
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
