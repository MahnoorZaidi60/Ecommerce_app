import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/product_vm.dart';
import '../../shared/product_card.dart';
import 'widgets/category_row.dart';
import 'widgets/home_banner.dart';
import 'widgets/flash_sale.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);
    final products = productVM.products;

    // ✅ Check Theme Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Search Bar Colors
    final searchFillColor = isDark ? const Color(0xFF1F1F1F) : Colors.grey[100];
    final searchIconColor = isDark ? Colors.grey : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Windigo"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: isDark ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            // 1. Search Bar (Fixed for Dark Mode)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (val) => productVM.search(val),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black), // Text Color
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: TextStyle(color: searchIconColor),
                    prefixIcon: Icon(Icons.search, color: searchIconColor),
                    fillColor: searchFillColor, // Dynamic Background
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Slightly more rounded
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Banner
            const SliverToBoxAdapter(child: HomeBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 3. Flash Sale (If you added it)
            const SliverToBoxAdapter(child: FlashSale()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 4. Categories
            const SliverToBoxAdapter(child: CategoryRow()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 5. "New Arrivals" Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Arrivals",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black, // Dynamic Text
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text("See All", style: TextStyle(color: isDark ? Colors.grey : Colors.black))
                    ),
                  ],
                ),
              ),
            ),

            // 6. Product Grid
            products.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    "No products found",
                    style: TextStyle(color: isDark ? Colors.grey : Colors.black),
                  ),
                ),
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ProductCard(product: products[index]);
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}