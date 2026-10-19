import '../config/constants.dart';

final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required';
  if (!_emailRegex.hasMatch(email)) return 'Enter a valid email address';
  return null;
}

String? validatePassword(String? value) {
  final password = value ?? '';
  if (password.isEmpty) return 'Password is required';
  if (password.length < kMinPasswordLength) {
    return 'Password must be at least $kMinPasswordLength characters';
  }
  return null;
}

String? validateAmount(String? value) {
  final text = value?.trim().replaceAll(',', '') ?? '';
  if (text.isEmpty) return 'Amount is required';
  final amount = double.tryParse(text);
  if (amount == null) return 'Enter a valid number';
  if (amount <= 0) return 'Amount must be greater than 0';
  return null;
}
