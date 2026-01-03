import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../view_models/cart_vm.dart';
import '../user/home/home_view.dart';
import '../user/cart/cart_view.dart';
import '../user/profile/order_history_view.dart';
import '../wishlist/wishlist_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const WishlistView(),
    const CartView(),
    const OrderHistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Dynamic Colors for Dark/Light Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? Colors.white : Colors.black;
    final unselectedColor = isDark ? Colors.grey : Colors.grey;
    final bgColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,

        // ✅ FIX: Use Dynamic Colors
        backgroundColor: bgColor,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        showUnselectedLabels: true,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartViewModel>(
              builder: (context, cartVM, child) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -10, end: -5),
                  showBadge: cartVM.itemCount > 0,
                  badgeContent: Text(
                    cartVM.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}