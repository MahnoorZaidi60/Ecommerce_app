import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../core/utils/routes.dart';

class SplashViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<void> init(BuildContext context) async {
    // 1. Wait for animation (Simulated delay)
    await Future.delayed(const Duration(seconds: 3));

    // 2. Check Shared Preferences (Has user seen Intro?)
    final prefs = await SharedPreferences.getInstance();
    final bool isIntroSeen = prefs.getBool('isIntroSeen') ?? false;

    // 3. Navigation Logic
    if (!context.mounted) return; // Safety check

    if (!isIntroSeen) {
      // Case A: First time user -> Go to Onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else {
      // Case B: Intro seen -> Check Login Status
      if (_authService.currentUser != null) {
        // User is logged in -> Go to Home
        Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
      } else {
        // User not logged in -> Go to Login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }
}