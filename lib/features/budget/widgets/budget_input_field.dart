import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme.dart';

/// Money input field shared by the budget and expense forms.
class BudgetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputAction textInputAction;

  const BudgetInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.textInputAction = TextInputAction.next,
  });

  OutlineInputBorder _border(Color c, {double w = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: AppTextStyles.title.copyWith(color: c.textPrimary),
      cursorColor: c.textPrimary,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return '$label is required';
        final n = double.tryParse(text);
        if (n == null) return 'Enter a valid amount';
        if (n <= 0) return 'Amount must be greater than 0';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.text.copyWith(color: c.textSecondary),
        floatingLabelStyle:
            AppTextStyles.text.copyWith(color: c.primary),
        prefixIcon: Icon(icon, color: c.primary),
        prefixText: '₱ ',
        prefixStyle: AppTextStyles.title.copyWith(color: c.textPrimary),
        filled: true,
        fillColor: c.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: AppTextStyles.text
            .copyWith(color: c.error, fontSize: 12),
        border: _border(Colors.transparent),
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(c.primary, w: 1.5),
        errorBorder: _border(c.error),
        focusedErrorBorder: _border(c.error, w: 1.5),
      ),
    );
  }
}
