import 'package:ecommerce_app/views/user/auth/login_view.dart';
import 'package:ecommerce_app/views/user/auth/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'view_models/auth_vm.dart';
import 'view_models/admin_vm.dart';
import 'view_models/cart_vm.dart';
import 'view_models/home_vm.dart';
import 'view_models/order_vm.dart';
import 'view_models/splash_vm.dart';
import 'view_models/onboarding_vm.dart';
import 'view_models/wishlist_vm.dart';

// Views
import 'views/splash/splash_view.dart';
import 'views/onboarding/onboarding_view.dart';
import 'views/main/main_nav_view.dart';
import 'views/admin/admin_login_view.dart';
import 'views/admin/dashboard_view.dart';
import 'views/admin/add_product_view.dart';

// Core
import 'core/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
      ],
      child: MaterialApp(
        title: "Windigo",
        debugShowCheckedModeBanner: false,

        // ☀️ LIGHT THEME (White BG, Black Elements)
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,

          // AppBar Style
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),

          // Button Style (BLACK Button in Light Mode)
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white, // Text Color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.black,
          ),
        ),

        // 🌙 DARK THEME (Black BG, White Elements)
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,

          // AppBar Style
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),

          // Button Style (WHITE Button in Dark Mode)
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black, // Text Color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.white,
          ),
        ),

        themeMode: ThemeMode.system, // Auto Detect

        // Routes
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashView(),
          AppRoutes.onboarding: (context) => const OnboardingView(),
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.register: (context) => const RegisterView(),
          AppRoutes.mainNav: (context) => const MainNavView(),
          AppRoutes.adminLogin: (context) => const AdminLoginView(),
          AppRoutes.adminDashboard: (context) => const AdminDashboardView(),
          AppRoutes.adminAddProduct: (context) => const AddProductView(),
        },
      ),
    );
  }
}