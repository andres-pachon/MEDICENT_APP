import 'package:flutter/material.dart';
// Verifica que esta ruta apunte correctamente a tu auth_service.dart
import '../../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    _isAuthenticated = success;
    _errorMessage = success ? null : 'Credenciales inválidas';
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}