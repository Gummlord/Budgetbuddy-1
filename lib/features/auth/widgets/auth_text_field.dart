import 'package:flutter/material.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? prefixIcon;
  final Iterable<String>? autofillHints;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(kDefaultRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints,
      obscureText: widget.isPassword && _obscure,
      style: AppTextStyles.body.copyWith(color: c.textPrimary),
      cursorColor: c.textPrimary,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        filled: true,
        fillColor: c.inputFill,
        enabledBorder: _border(Colors.transparent),
        focusedBorder: _border(c.primary, 1.5),
        errorBorder: _border(c.error),
        focusedErrorBorder: _border(c.error, 1.5),
        labelStyle:
            AppTextStyles.body.copyWith(color: c.textSecondary),
        floatingLabelStyle: AppTextStyles.body.copyWith(
          color: c.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: AppTextStyles.body.copyWith(
          color: c.error,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: c.textSecondary),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: c.textSecondary,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
