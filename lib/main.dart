import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// --- Imports for ViewModels & Services ---
import 'view_models/auth_vm.dart';
import 'view_models/product_vm.dart';
import 'view_models/cart_vm.dart';
import 'view_models/wishlist_vm.dart';
import 'view_models/splash_vm.dart';
import 'view_models/onboarding_vm.dart';
import 'view_models/admin_vm.dart';
import 'services/auth_service.dart';

// --- Imports for Theme & Routes ---
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  try {

    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- View Models ---
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),

        // --- Services ---
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,

        // Theme Settings
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Routes
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}