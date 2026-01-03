import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/routes.dart';

class OnboardingViewModel with ChangeNotifier {

  // Method called when user clicks "Get Started"
  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Save that user has seen the intro
    await prefs.setBool('isIntroSeen', true);

    if (!context.mounted) return;

    // Navigate to Login
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}