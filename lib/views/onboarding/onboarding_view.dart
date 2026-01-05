import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../view_models/onboarding_vm.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 👟 Premium Shoe Images (Direct URLs for instant look)
  final List<Map<String, String>> _pages = [
    {
      "title": "PREMIUM COMFORT",
      "desc": "Experience the finest materials crafted for your feet. Walk with confidence and style.",
      "image": "https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=600&auto=format&fit=crop", // Nike Shoe
    },
    {
      "title": "LATEST TRENDS",
      "desc": "Stay ahead of the fashion curve with our exclusive collection of sneakers and formals.",
      "image": "https://images.unsplash.com/photo-1603808033192-082d6919d3e1?q=80&w=600&auto=format&fit=crop", // Fashion Shoe
    },
    {
      "title": "SWIFT DELIVERY",
      "desc": "Get your favorite pairs delivered to your doorstep faster than ever before.",
      "image": "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=600&auto=format&fit=crop", // Running Shoe
    },
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OnboardingViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Windigo Colors
    final textColor = isDark ? Colors.white : AppColors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Black/White auto
      body: SafeArea(
        child: Column(
          children: [
            // 1. SKIP BUTTON (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 10),
                child: TextButton(
                  onPressed: () => vm.completeOnboarding(context),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1
                    ),
                  ),
                ),
              ),
            ),

            // 2. SLIDER CONTENT
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // A. IMAGE (Rounded Corners & Shadow)
                        Container(
                          height: 320,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                            image: DecorationImage(
                              image: NetworkImage(_pages[index]["image"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // B. TITLE (Big & Bold)
                        Text(
                          _pages[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900, // Extra Bold
                            color: textColor,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // C. DESCRIPTION
                        Text(
                          _pages[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: subTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. BOTTOM CONTROLS (Dots & Button)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // DOTS INDICATOR
                  Row(
                    children: List.generate(
                      _pages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 6,
                        width: _currentPage == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? textColor : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),

                  // NEXT / START BUTTON
                  ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, // Black button on light mode
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}