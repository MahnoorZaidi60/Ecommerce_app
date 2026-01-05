import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/routes.dart';

class OnboardingViewModel with ChangeNotifier {

  // Method called when user clicks "Get Started"
  Future<void> completeOnboarding(BuildContext context) async {
    // 1. Save "Seen" status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIntroSeen', true);

    if (!context.mounted) return;

    // 2. Navigate to Login
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}