import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Note: Import path depends on your project name.
// If project name is 'ecommerce_app', import like this:
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/core/constants/app_assets.dart';

void main() {
  group('Core Constants Tests', () {

    test('AppColors should have correct primary color', () {
      expect(AppColors.primary, const Color(0xFFF57224));
      expect(AppColors.secondary, const Color(0xFF2E3192));
    });

    test('AppStrings should not be empty', () {
      expect(AppStrings.appName.isNotEmpty, true);
      expect(AppStrings.currency, 'PKR');
    });

    test('AppAssets Lottie URLs should be valid network links', () {
      expect(AppAssets.animSplash.startsWith('http'), true);
      expect(AppAssets.animOnboarding1.startsWith('http'), true);
    });
  });
}