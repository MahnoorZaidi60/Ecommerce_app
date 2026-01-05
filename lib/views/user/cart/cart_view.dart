import 'dart:convert'; // ✅ Base64
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../models/cart_model.dart'; // Make sure this path is correct
import '../../../../view_models/cart_vm.dart';
import '../../shared/custom_button.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "MY BAG (${cartVM.itemCount})",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: textColor,
            fontSize: 16,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          if (cartVM.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showClearCartDialog(context, cartVM),
            ),
        ],
      ),
      body: cartVM.itemCount == 0
          ? _buildEmptyCart(textColor)
          : Column(
        children: [
          // 1. CART LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartVM.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartVM.cartItems[index];
                return _CartItemTile(item: item, cartVM: cartVM);
              },
            ),
          ),

          // 2. CHECKOUT SECTION (Total + Button)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: TextStyle(color: Colors.grey.shade500)),
                      Text(
                        "PKR ${cartVM.totalAmount.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "CHECKOUT NOW",
                    onPressed: () {
                      _showAddressSheet(context, cartVM);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🗑️ Helper: Clear Cart Dialog
  void _showClearCartDialog(BuildContext context, CartViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear Bag?"),
        content: const Text("Are you sure you want to remove all items?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              vm.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 📝 Helper: Address Input Sheet
  void _showAddressSheet(BuildContext context, CartViewModel vm) {
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Keyboard ke upar aaye
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20, left: 20, right: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Shipping Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter full address (House, Street, City)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "CONFIRM ORDER (COD)",
              isLoading: vm.isPlacingOrder,
              onPressed: () async {
                if (addressController.text.isNotEmpty) {
                  Navigator.pop(ctx); // Close Sheet
                  await vm.placeOrder(context, addressController.text.trim());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 📭 Helper: Empty State
  Widget _buildEmptyCart(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            "YOUR BAG IS EMPTY",
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: textColor
            ),
          ),
          const SizedBox(height: 10),
          const Text("Looks like you haven't made your choice yet."),
        ],
      ),
    );
  }
}

// =======================================================
// 🧩 SUB-WIDGET: Cart Item Tile
// =======================================================
class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final CartViewModel cartVM;

  const _CartItemTile({required this.item, required this.cartVM});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // A. IMAGE (Base64)
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.isNotEmpty
                  ? Image.memory(base64Decode(item.imageUrl), fit: BoxFit.cover)
                  : const Icon(Icons.image),
            ),
          ),

          const SizedBox(width: 16),

          // B. DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Size: ${item.selectedSize} | PKR ${item.price.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),

                // QUANTITY CONTROLS
                Row(
                  children: [
                    _qtyBtn(Icons.remove, () => cartVM.decreaseQuantity(item), isDark),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyBtn(Icons.add, () => cartVM.increaseQuantity(item), isDark),
                  ],
                ),
              ],
            ),
          ),

          // C. REMOVE BUTTON
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
            onPressed: () => cartVM.removeFromCart(item),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}