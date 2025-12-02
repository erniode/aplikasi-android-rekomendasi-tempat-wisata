import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  // -------------------------
  // LOGIN
  // -------------------------
  Future<bool> login(String username, String password) async {
    // simulasi backend
    await Future.delayed(const Duration(milliseconds: 500));

    if ((username == 'user' && password == 'pass123') ||
        (username == 'admin' && password == 'admin')) {
      _user = UserModel(id: 1, username: username, password: password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      await prefs.setString('username', username);

      notifyListeners();
      return true;
    }
    return false;
  }

  // -------------------------
  // REGISTER
  // -------------------------
  Future<bool> register(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Validasi contoh (backend dummy)
    if (username.length < 3 || password.length < 3) {
      return false;
    }

    // Simulasi akun baru
    _user = UserModel(id: 2, username: username, password: password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    await prefs.setString('username', username);

    notifyListeners();
    return true;
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    await prefs.remove('username');
    notifyListeners();
  }

  // -------------------------
  // AUTO LOGIN
  // -------------------------
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('logged_in') ?? false;

    if (logged) {
      final username = prefs.getString('username') ?? 'user';
      _user = UserModel(
        id: 1,
        username: username,
        password: '', // password tidak disimpan demi keamanan
      );
      notifyListeners();
    }
  }
}
