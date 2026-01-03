import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../models/product_model.dart';
import '../../../../view_models/cart_vm.dart';
import '../../../../view_models/wishlist_vm.dart';
import '../../shared/custom_button.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get Product Data from Arguments (passed when clicking a card)
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      // Allow content to go behind status bar for a premium look
      body: CustomScrollView(
        slivers: [
          // A. App Bar with Large Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Back Button and Wishlist Icon
            actions: [
              Consumer<WishlistViewModel>(
                builder: (context, wishlistVM, _) {
                  final isLiked = wishlistVM.isInWishlist(product.id);
                  return IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : AppColors.black,
                    ),
                    onPressed: () => wishlistVM.toggleWishlist(product),
                  );
                },
              ),
            ],
          ),

          // B. Product Details
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price
                    Text(
                      "${AppStrings.currency} ${product.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Name
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    const Divider(thickness: 1, height: 30),

                    // Description Title
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description Text
                    Text(
                      product.description,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),

                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // C. Bottom "Add to Cart" Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Chat/Store Button (Visual only)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.store, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: Consumer<CartViewModel>(
                  builder: (context, cartVM, child) {
                    return CustomButton(
                      text: "Add to Cart",
                      onPressed: () {
                        cartVM.addToCart(product);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}