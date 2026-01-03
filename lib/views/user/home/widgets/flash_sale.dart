import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../view_models/product_vm.dart';
import '../../../shared/product_card.dart';


class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Product ViewModel
    final productVM = Provider.of<ProductViewModel>(context);

    // Filter only products marked as "isSale"
    // (Ensure your ProductModel has isSale, or just show first 5 items as dummy flash sale)
    final saleProducts = productVM.products.where((p) => p.isSale).toList();

    if (saleProducts.isEmpty) return const SizedBox.shrink(); // Hide if no sale items

    return Column(
      children: [
        // Header with Timer (Visual only)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Flash Sale",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  _buildTimerBox("02"),
                  const Text(" : "),
                  _buildTimerBox("15"),
                  const Text(" : "),
                  _buildTimerBox("30"),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text("Shop More")),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal List
        SizedBox(
          height: 240, // Height for the card
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: saleProducts.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160, // Fixed width for horizontal items
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ProductCard(product: saleProducts[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper for the red timer boxes
  Widget _buildTimerBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}