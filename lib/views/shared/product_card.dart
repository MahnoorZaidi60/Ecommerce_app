import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../view_models/wishlist_vm.dart';

// ✅ CORRECT IMPORT (User/Home Folder)
import '../user/home/product_detail_view.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistVM = Provider.of<WishlistViewModel>(context);
    final isLiked = wishlistVM.wishlist.any((item) => item.id == product.id);

    return GestureDetector(
      onTap: () {
        // ✅ CORRECT NAME: ProductDetailView (No 's')
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailView(product: product)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGE SECTION
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: product.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[200]),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    )
                        : Image.memory(
                      base64Decode(product.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey)),
                    ),
                  ),

                  // Heart Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                        onPressed: () {
                          wishlistVM.toggleWishlist(product);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),

            // 2. DETAILS SECTION
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${AppStrings.currency} ${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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