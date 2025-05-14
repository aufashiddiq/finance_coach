import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/database_service.dart';

class AppStateProvider extends ChangeNotifier {
  final AuthService authService;
  final DatabaseService databaseService;

  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.system;
  String? _errorMessage;

  AppStateProvider({required this.authService, required this.databaseService});

  // Getters
  bool get isLoading => _isLoading;
  bool get isUserLoggedIn => authService.currentUser != null;
  ThemeMode get themeMode => _themeMode;
  String? get errorMessage => _errorMessage;

  // Methods
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      final result = await authService.login(email, password);
      setLoading(false);
      return result;
    } catch (e) {
      setLoading(false);
      setErrorMessage(e.toString());
      return false;
    }
  }

  Future<bool> signup(String email, String password, String name) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      final result = await authService.signup(email, password, name);
      setLoading(false);
      return result;
    } catch (e) {
      setLoading(false);
      setErrorMessage(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    setLoading(true);
    try {
      await authService.logout();
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
