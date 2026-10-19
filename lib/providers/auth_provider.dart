import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService() {
    _subscription = _authService.authStateChanges.listen(
      _onAuthChanged,
      onError: (_) {
        _isInitializing = false;
        notifyListeners();
      },
    );
  }

  final AuthService _authService;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? _user;
  bool _isInitializing = true;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _onAuthChanged(AppUser? user) {
    _user = user;
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> register({required String email, required String password}) {
    return _run(() async {
      _user = await _authService.register(email: email, password: password);
    });
  }

  Future<bool> login({required String email, required String password}) {
    return _run(() async {
      _user = await _authService.login(email: email, password: password);
    });
  }

  Future<void> logout() => _authService.logout();

  void clearError({bool notify = true}) {
    _errorMessage = null;
    if (notify) notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      debugPrint('Auth error: $e');
      _errorMessage = 'Unexpected error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
