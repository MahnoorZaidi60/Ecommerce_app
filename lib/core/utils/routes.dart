import 'package:flutter/material.dart';


import '../../views/admin/admin_login_view.dart';
import '../../views/splash/splash_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/user/auth/login_view.dart';
import '../../views/user/auth/register_view.dart';
import '../../views/main/main_nav_view.dart'; // Bottom Nav Container
import '../../views/user/home/home_view.dart';
import '../../views/user/home/product_detail_view.dart';
import '../../views/user/cart/cart_view.dart';
import '../../views/user/profile/order_history_view.dart';
import '../../views/admin/dashboard_view.dart';
import '../../views/admin/add_product_view.dart';

class AppRoutes {
  // Route Names (Constants)
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String mainNav = '/main-nav'; // Bottom Bar Holder
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String orders = '/orders';

  // Admin Routes
  static const String adminDashboard = '/admin-dashboard';
  static const String adminAddProduct = '/admin-add-product';
  static const String adminLogin = '/admin-login';

  // Route Map (Main.dart mein use hoga)
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashView(),
    onboarding: (context) => const OnboardingView(),
    login: (context) => const LoginView(),
    register: (context) => const RegisterView(),
    mainNav: (context) => const MainNavView(), // Iske andar Home hoga
    // home: (context) => const HomeView(), // Direct home access rarely needed due to MainNav
    cart: (context) => const CartView(),
    orders: (context) => const OrderHistoryView(),

    // Admin
    adminDashboard: (context) => const AdminDashboardView(),
    adminAddProduct: (context) => const AddProductView(),
    adminLogin: (context) => const AdminLoginView(),
  };
}