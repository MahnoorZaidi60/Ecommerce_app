import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/routes.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../services/database_service.dart';
import '../../view_models/admin_vm.dart';
import '../../view_models/auth_vm.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    // 🎨 Dynamic Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;

    // AppBar hamesha Black rahega
    const appBarColor = Colors.black;
    const appBarTextColor = Colors.white;

    // Button Colors (User ki demand par fix)
    final btnColor = isDark ? Colors.white : Colors.black; // Dark mein White Button
    final btnTextColor = isDark ? Colors.black : Colors.white; // Text opposite hoga

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,

        // 1. APP BAR
        appBar: AppBar(
          title: Text(
            "ADMIN DASHBOARD",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: appBarTextColor,
            ),
          ),
          backgroundColor: appBarColor,
          centerTitle: false,
          automaticallyImplyLeading: false, // Back button removed

          iconTheme: const IconThemeData(color: appBarTextColor),

          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () => authVM.logout(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag_outlined), text: "Manage Shoes"),
              Tab(icon: Icon(Icons.list_alt_outlined), text: "All Orders"),
            ],
          ),
        ),

        // 2. ADD BUTTON (✅ Fixed for Dark Mode)
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: btnColor, // Dynamic BG
          icon: Icon(Icons.add, color: btnTextColor), // Dynamic Icon
          label: Text("ADD SHOE", style: TextStyle(color: btnTextColor, fontWeight: FontWeight.bold)), // Dynamic Text
          onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
        ),

        // 3. BODY (Tabs)
        body: const TabBarView(
          children: [
            _ProductsTab(), // Shoes List
            _OrdersTab(),   // Orders List
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------
// 👟 TAB 1: MANAGE PRODUCTS (Shoes List)
// ------------------------------------------------------
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();
    final adminVM = Provider.of<AdminViewModel>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return StreamBuilder<List<ProductModel>>(
      stream: dbService.productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return Center(child: Text("No shoes added yet.", style: TextStyle(color: textColor)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Card(
              color: cardColor,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      base64Decode(product.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 30),
                    ),
                  )
                      : const Icon(Icons.image_not_supported),
                ),

                title: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor)
                ),
                subtitle: Text(
                  "PKR ${product.price.toStringAsFixed(0)} • Size: ${product.availableSizes.join(', ')}",
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Shoe?"),
                          content: const Text("This action cannot be undone."),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                adminVM.deleteProduct(product.id);
                                Navigator.pop(ctx);
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ------------------------------------------------------
// 📦 TAB 2: ALL ORDERS (For Admin)
// ------------------------------------------------------
class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return StreamBuilder<List<OrderModel>>(
      stream: dbService.getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return Center(child: Text("No orders received yet.", style: TextStyle(color: textColor)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];

            Color statusColor = Colors.orange;
            if (order.status == 'Delivered') statusColor = Colors.green;
            if (order.status == 'Cancelled') statusColor = Colors.red;

            return Card(
              color: cardColor,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                iconColor: textColor,
                collapsedIconColor: textColor,
                tilePadding: const EdgeInsets.all(16),

                title: Text(
                    "Order #${order.orderId.substring(0, 5)}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor)
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User: ${order.userName}", style: TextStyle(color: textColor)),
                    Text(
                        "Total: PKR ${order.totalAmount.toStringAsFixed(0)}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor)
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(order.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shipping Address:", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        Text(order.shippingAddress, style: TextStyle(color: textColor)),
                        const Divider(),
                        Text("Items:", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.quantity}x ${item.name} (${item.selectedSize})",
                                style: TextStyle(color: textColor),
                              ),
                              Text(
                                "PKR ${item.price}",
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 10),

                        // Status Update Buttons
                        if (order.status == 'Pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => dbService.updateOrderStatus(order.orderId, "Delivered"),
                                child: const Text("Mark Delivered", style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}