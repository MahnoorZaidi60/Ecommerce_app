import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/routes.dart';
import '../models/user_model.dart';

class SplashViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> init(BuildContext context) async {
    // 1. Thoda wait karein (Logo dikhane ke liye)
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    // 2. Check: Kya User ne Onboarding dekha hai?
    final prefs = await SharedPreferences.getInstance();
    final bool isIntroSeen = prefs.getBool('isIntroSeen') ?? false;

    if (!isIntroSeen) {
      // 👉 New User -> Show Onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else {
      // 👉 Old User -> Check Login Status
      await _checkLoginStatus(context);
    }
  }

  // Helper: Login Check logic
  Future<void> _checkLoginStatus(BuildContext context) async {
    User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      // 🕵️‍♂️ User Logged In hai. Check karo ADMIN hai ya nahi?
      try {
        DocumentSnapshot doc = await _db.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>, firebaseUser.uid);

          if (user.isAdmin) {
            // 👑 Admin -> Dashboard
            Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
          } else {
            // 👟 Customer -> Shop
            Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
          }
        } else {
          // Data corrupt? Login par bhejo
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      } catch (e) {
        // Error? Login par bhejo
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } else {
      // ❌ Not Logged in -> Go to Login Page
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }
}