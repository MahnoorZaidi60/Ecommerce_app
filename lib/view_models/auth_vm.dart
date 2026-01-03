import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../core/utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For error popups

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Helper to toggle spinner
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --- LOGIN ---
  Future<void> login(String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
      await _authService.signIn(email: email, password: password);

      if (!context.mounted) return;
      // Success -> Go to Home
      Navigator.pushReplacementNamed(context, AppRoutes.mainNav);

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  // --- REGISTER ---
  Future<void> register(String email, String password, String name, BuildContext context) async {
    _setLoading(true);
    try {
      // 1. Create Auth User
      User? user = await _authService.signUp(email: email, password: password);

      if (user != null) {
        // 2. Save User Details to Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
        );
        await _dbService.saveUserData(newUser);

        if (!context.mounted) return;
        // Success -> Go to Home (or Login)
        Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  // --- LOGOUT ---
  Future<void> logout(BuildContext context) async {
    await _authService.signOut();
    if (!context.mounted) return;
    // Clear stack and go to login
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }
}