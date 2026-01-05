import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
    // Logic start karo (Admin/User check)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SplashViewModel>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ⚫ Pure Black Background (Premium)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. BRAND NAME (No Animation, Just Class)
            Text(
              "WINDIGO",
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.w900, // Extra Bold
                letterSpacing: 8, // ↔️ Wide spacing luxury look deta hai
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // 2. Minimal Loader
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}