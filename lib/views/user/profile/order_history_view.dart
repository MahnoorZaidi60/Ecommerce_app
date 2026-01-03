import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../models/order_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/database_service.dart';
import '../../../../view_models/auth_vm.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false); // Direct service access for ID
    final dbService = DatabaseService();
    final authVM = Provider.of<AuthViewModel>(context);

    // Get current user ID
    final userId = authService.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text("Please login to view orders"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile & Orders"),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Logout",
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx); // Close dialog
                        authVM.logout(context); // Perform logout
                      },
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. User Info Header (Simple)
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authService.currentUser?.email ?? "User",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text("Customer", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 2. Orders List Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 3. Orders Stream
          Expanded(
            child: StreamBuilder<List<OrderModel>>(
              stream: dbService.getUserOrders(userId),
              builder: (context, snapshot) {
                // Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Empty State
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No orders placed yet"),
                      ],
                    ),
                  );
                }

                // List Data
                return ListView.builder(
                  itemCount: orders.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Single Order Card
  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    // Format Date (requires intl package)
    final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(order.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(12),
        // A. Header (Status & Total)
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(order.status),
            color: _getStatusColor(order.status),
          ),
        ),
        title: Text(
          "${AppStrings.currency} ${order.totalAmount.toStringAsFixed(0)}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Date: $dateStr", style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              "Status: ${order.status}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(order.status),
              ),
            ),
          ],
        ),

        // B. Expanded Children (List of Items bought)
        children: order.items.map((item) {
          return ListTile(
            dense: true,
            leading: const Icon(Icons.shopping_bag_outlined, size: 20),
            title: Text(item.name),
            trailing: Text("x${item.quantity}"),
            subtitle: Text("${AppStrings.currency} ${item.price.toStringAsFixed(0)}"),
          );
        }).toList(),
      ),
    );
  }

  // Helper: Status Colors
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'shipped':
        return Colors.blue;
      default:
        return Colors.orange; // Pending
    }
  }

  // Helper: Status Icons
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'shipped':
        return Icons.local_shipping_outlined;
      default:
        return Icons.hourglass_empty; // Pending
    }
  }
}