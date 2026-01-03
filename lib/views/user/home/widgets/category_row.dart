import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/product_vm.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ["All", "Electronics", "Fashion", "Home", "Beauty", "Sports"];
    final productVM = Provider.of<ProductViewModel>(context);

    // ✅ Theme Check
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Chip Colors
    final chipBgColor = isDark ? const Color(0xFF1F1F1F) : Colors.grey[100];
    final chipTextColor = isDark ? Colors.white : Colors.black;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ActionChip(
              label: Text(cat),
              backgroundColor: chipBgColor, // Dynamic BG
              labelStyle: TextStyle(
                color: chipTextColor, // Dynamic Text
                fontWeight: FontWeight.w500,
              ),
              onPressed: () {
                productVM.filterByCategory(cat);
              },
              side: BorderSide.none, // Remove Border
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }
}