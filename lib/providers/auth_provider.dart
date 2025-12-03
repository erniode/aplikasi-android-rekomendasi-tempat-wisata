import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _auth.currentUser != null;

  // -------------------------
  // LOGIN (Firebase)
  // -------------------------
  Future<bool> login(String username, String password) async {
    try {
      // Firebase memakai email untuk username
      final result = await _auth.signInWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // Buat local user model
      _user = UserModel(
        id: result.user?.uid.hashCode ?? 0,
        username: result.user?.email ?? username,
        password: '', // tidak menyimpan password
      );

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("LOGIN ERROR: ${e.message}");
      return false;
    }
  }

  // -------------------------
  // REGISTER (Firebase)
  // -------------------------
  Future<bool> register(String username, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      _user = UserModel(
        id: result.user?.uid.hashCode ?? 0,
        username: result.user?.email ?? username,
        password: '',
      );

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("REGISTER ERROR: ${e.message}");
      return false;
    }
  }

  // -------------------------
  // LOGOUT (Firebase)
  // -------------------------
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // -------------------------
  // AUTO LOGIN
  // -------------------------
  Future<void> tryAutoLogin() async {
    final current = _auth.currentUser;

    if (current != null) {
      _user = UserModel(
        id: current.uid.hashCode,
        username: current.email ?? '',
        password: '',
      );
      notifyListeners();
    }
  }
}
