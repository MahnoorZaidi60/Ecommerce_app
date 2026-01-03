import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../view_models/splash_vm.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Start the timer/logic immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SplashViewModel>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Orange Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Lottie Animation
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.network(
                AppAssets.animSplash,
                fit: BoxFit.fill,
                // Add error builder in case network fails
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.shopping_bag, color: Colors.white, size: 80);
                },
              ),
            ),
            const SizedBox(height: 20),

            // 2. Loading Spinner (White)
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}