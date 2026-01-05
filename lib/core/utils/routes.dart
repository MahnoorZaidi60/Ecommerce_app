import 'package:flutter/material.dart';

// User Views
import '../../views/splash/splash_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/user/auth/login_view.dart';
import '../../views/user/auth/register_view.dart';
import '../../views/main/main_nav_view.dart'; // Bottom Nav Holder
import '../../views/user/cart/cart_view.dart';
import '../../views/user/profile/order_history_view.dart';

// Admin Views
import '../../views/admin/admin_login_view.dart';
import '../../views/admin/dashboard_view.dart';
import '../../views/admin/add_product_view.dart';

class AppRoutes {
  // --- Constants (Naam) ---
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNav = '/main-nav'; // Home iske andar hai
  static const String cart = '/cart';
  static const String orders = '/orders';

  // Note: Product Detail ka route naam hum use nahi karenge,
  // hum direct data pass karenge.

  // --- Admin Routes ---
  static const String adminLogin = '/admin-login';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminAddProduct = '/admin-add-product';

  // --- Route Map (Navigation Logic) ---
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashView(),
    onboarding: (context) => const OnboardingView(),
    login: (context) => const LoginView(),
    register: (context) => const RegisterView(),

    // Main Container (Bottom Bar + Home)
    mainNav: (context) => const MainNavView(),

    // User Screens
    cart: (context) => const CartView(),
    orders: (context) => const OrderHistoryView(),

    // Admin Screens
    adminLogin: (context) => const AdminLoginView(),
    adminDashboard: (context) => const AdminDashboardView(),
    adminAddProduct: (context) => const AddProductView(),
  };
}