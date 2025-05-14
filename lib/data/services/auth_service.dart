import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String uid;
  final String email;
  final String name;

  User({required this.uid, required this.email, required this.name});
}

class AuthService {
  User? _currentUser;
  late SharedPreferences _prefs;

  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    // Check if user is logged in
    final String? userEmail = _prefs.getString('user_email');
    final String? userName = _prefs.getString('user_name');
    final String? userId = _prefs.getString('user_id');

    if (userEmail != null && userName != null && userId != null) {
      _currentUser = User(uid: userId, email: userEmail, name: userName);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // TODO: Replace with actual authentication implementation
      // This is a mock implementation for demonstration
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      if (email == 'test@example.com' && password == 'password') {
        _currentUser = User(uid: 'user_123', email: email, name: 'Test User');

        // Save user info to SharedPreferences
        await _prefs.setString('user_email', email);
        await _prefs.setString('user_name', 'Test User');
        await _prefs.setString('user_id', 'user_123');

        return true;
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      // TODO: Replace with actual signup implementation
      // This is a mock implementation for demonstration
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      _currentUser = User(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
      );

      // Save user info to SharedPreferences
      await _prefs.setString('user_email', email);
      await _prefs.setString('user_name', name);
      await _prefs.setString('user_id', _currentUser!.uid);

      return true;
    } catch (e) {
      debugPrint('Signup error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Replace with actual logout implementation
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      _currentUser = null;

      // Clear user info from SharedPreferences
      await _prefs.remove('user_email');
      await _prefs.remove('user_name');
      await _prefs.remove('user_id');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }
}
