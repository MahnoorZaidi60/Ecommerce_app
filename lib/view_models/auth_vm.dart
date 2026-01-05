import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../core/utils/routes.dart';
import '../models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // ✅ LOGIN FUNCTION
  Future<void> login(String email, String password, BuildContext context) async {
    setLoading(true);
    try {
      // 1. Firebase Auth Login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Check Firestore for Admin Role
      DocumentSnapshot doc = await _db.collection('users').doc(userCredential.user!.uid).get();

      setLoading(false); // Stop Loading

      if (doc.exists) {
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>, userCredential.user!.uid);

        if (!context.mounted) return;

        if (user.isAdmin) {
          // 👑 Admin -> Dashboard
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        } else {
          // 👤 User -> Home
          Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
        }
      } else {
        // Fallback if data missing
        Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
      }

    } on FirebaseAuthException catch (e) {
      setLoading(false); // Stop Loading on Error
      Fluttertoast.showToast(msg: e.message ?? "Login Failed", backgroundColor: Colors.red);
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: "Something went wrong", backgroundColor: Colors.red);
      debugPrint("Login Error: $e");
    }
  }

  // ✅ REGISTER FUNCTION
  Future<void> register(String email, String password, String name, String phone, String address, BuildContext context) async {
    setLoading(true);
    try {
      // 1. Create User in Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create User Model
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        address: address,
        isAdmin: false, // Default User
      );

      // 3. Save to Firestore
      await _db.collection('users').doc(newUser.uid).set(newUser.toMap());

      setLoading(false);

      if (!context.mounted) return;
      Fluttertoast.showToast(msg: "Account Created! Please Login.");
      Navigator.pop(context); // Go back to Login

    } on FirebaseAuthException catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: e.message ?? "Registration Failed", backgroundColor: Colors.red);
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red);
    }
  }

  // 🚪 LOGOUT
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }
}