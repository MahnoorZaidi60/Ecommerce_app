import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../core/utils/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../view_models/wishlist_vm.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Access Wishlist Logic
    final wishlistVM = Provider.of<WishlistViewModel>(context);
    final isLiked = wishlistVM.isInWishlist(product.id);

    return GestureDetector(
      onTap: () {
        // Navigate to Details Page
        Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Clips image to rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image with Wishlist Button
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  // Heart Icon (Top Right)
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

            // 2. Details (Name & Price)
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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