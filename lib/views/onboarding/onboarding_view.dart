import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../view_models/onboarding_vm.dart';
import '../shared/custom_button.dart'; // We just made this!

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data for the 3 slides
  final List<Map<String, String>> _pages = [
    {
      "title": AppStrings.onbTitle1,
      "desc": AppStrings.onbDesc1,
      "anim": AppAssets.animOnboarding1,
    },
    {
      "title": AppStrings.onbTitle2,
      "desc": AppStrings.onbDesc2,
      "anim": AppAssets.animOnboarding2,
    },
    {
      "title": AppStrings.onbTitle3,
      "desc": AppStrings.onbDesc3,
      "anim": AppAssets.animOnboarding3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OnboardingViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Skip Button (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => vm.completeOnboarding(context),
                child: const Text("Skip"),
              ),
            ),

            // 2. Slidable Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildPageContent(
                    _pages[index]["title"]!,
                    _pages[index]["desc"]!,
                    _pages[index]["anim"]!,
                  );
                },
              ),
            ),

            // 3. Dots Indicator & Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get Started Button
                  CustomButton(
                    text: _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        vm.completeOnboarding(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Page Content (Internal)
  Widget _buildPageContent(String title, String desc, String anim) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation
          Expanded(
            flex: 3,
            child: Lottie.network(anim, fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  // Helper for Dots
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}