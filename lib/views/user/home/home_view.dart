import 'dart:convert'; // For Base64 Images
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../models/product_model.dart';
import '../../../../view_models/home_vm.dart';
import 'product_detail_view.dart'; // ✅ Connects to Details Page

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧠 Connect to HomeViewModel
    final homeVM = Provider.of<HomeViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F8F8), // Premium BG

      // 1. APP BAR (Windigo Style)
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "WINDIGO",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            fontSize: 24,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: isDark ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 2. SEARCH BAR
            TextField(
              onChanged: (val) => homeVM.setSearchQuery(val),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Search sneakers...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                fillColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 25),

            // 3. FLASH SALE SLIDER (Real Data from Firestore)
            Text(
              "FLASH SALE 🔥",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 200,
              child: StreamBuilder<List<ProductModel>>(
                stream: homeVM.flashSaleStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                      child: const Text("No Sales Active"),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return _SaleCard(product: product);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // 4. CATEGORIES (Chips)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: homeVM.categories.map((cat) {
                  final isSelected = homeVM.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: isDark ? Colors.white : Colors.black,
                      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                      labelStyle: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white : Colors.black),
                          fontWeight: FontWeight.bold
                      ),
                      onSelected: (_) => homeVM.setCategory(cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),

            // 5. ALL PRODUCTS GRID
            Text(
              "NEW ARRIVALS",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            StreamBuilder<List<ProductModel>>(
              stream: homeVM.allProductsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Apply Filters locally
                final allProducts = snapshot.data ?? [];
                final filteredProducts = homeVM.filterProducts(allProducts);

                if (filteredProducts.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text("No shoes found."),
                  ));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70, // Height adjust for shoe card
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _ProductCard(product: filteredProducts[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------
// 🧩 SUB-WIDGET: Product Card (Grid Item)
// --------------------------------------------------------
// Sirf _ProductCard wala hissa replace karein (neeche scroll karein file mein)

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailView(product: product))
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ HERO ANIMATION ADDED HERE
            Expanded(
              child: Hero(
                tag: product.id, // 🔑 Unique Tag (Important)
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.memory(
                      base64Decode(product.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (c,o,s) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  )
                      : const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // Text Details (No Change)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "PKR ${product.price.toStringAsFixed(0)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontSize: 12
                    ),
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

// --------------------------------------------------------
// 🧩 SUB-WIDGET: Sale Card (Slider Item)
// --------------------------------------------------------
class _SaleCard extends StatelessWidget {
  final ProductModel product;
  const _SaleCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailView(product: product))
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.black, // Always Dark for Flash Sale
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: MemoryImage(base64Decode(product.imageUrl)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: const Text("SALE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
              ),
              Text(
                  "PKR ${product.price.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.white70)
              ),
            ],
          ),
        ),
      ),
    );
  }
}