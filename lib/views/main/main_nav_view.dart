import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../view_models/cart_vm.dart';


import '../user/home/home_view.dart';
import '../user/cart/cart_view.dart';
import '../wishlist/wishlist_view.dart';
import '../user/profile/order_history_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0; // Default: Home

  // ✅ 4 SCREENS LIST (Order Important Hai!)
  final List<Widget> _screens = [
    const HomeView(),          // Index 0
    const WishlistView(),      // Index 1
    const CartView(),          // Index 2
    const OrderHistoryView(),  // Index 3 (Profile/Account)
  ];

  @override
  Widget build(BuildContext context) {
    // 🎨 Theme Logic
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? Colors.black : Colors.white;
    final selectedItemColor = isDark ? Colors.white : Colors.black;
    final unselectedItemColor = Colors.grey;

    return Scaffold(
      // ✅ IndexedStack State ko preserve rakhta hai (Refresh nahi hota)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? Colors.grey.shade900 : Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          backgroundColor: navBgColor,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // 4 items ke liye zaroori
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          showSelectedLabels: true,
          showUnselectedLabels: false,

          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold),

          items: [
            // 1. Home
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),

            // 2. Wishlist
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: "Saved",
            ),

            // 3. Cart (Badge ke saath)
            BottomNavigationBarItem(
              icon: Consumer<CartViewModel>(
                builder: (_, cartVM, __) => Badge(
                  label: Text(cartVM.itemCount.toString()),
                  isLabelVisible: cartVM.itemCount > 0,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              activeIcon: const Icon(Icons.shopping_bag),
              label: "Bag",
            ),

            // 4. Account (Profile)
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}