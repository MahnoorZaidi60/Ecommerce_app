import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/database_service.dart';
import 'package:intl/intl.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    return StreamBuilder<List<OrderModel>>(
      stream: dbService.getAllOrders(), // Fetch ALL orders
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text("No orders received yet"),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                // Header
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(order.status).withOpacity(0.2),
                  child: Icon(_getStatusIcon(order.status), color: _getStatusColor(order.status)),
                ),
                title: Text(
                  "Order #${order.orderId.substring(0, 5).toUpperCase()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${DateFormat('dd MMM').format(order.date)} • ${order.items.length} Items",
                ),
                trailing: Text(
                  "Rs. ${order.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                // Details Body
                children: [
                  const Divider(),
                  // Product List inside Order
                  ...order.items.map((item) => ListTile(
                    dense: true,
                    title: Text(item.name),
                    trailing: Text("x${item.quantity}"),
                    leading: const Icon(Icons.shopping_bag_outlined, size: 16),
                  )),

                  // Admin Action Buttons (TODO: Add Update Status logic if needed)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Chip(
                          label: Text(order.status),
                          backgroundColor: _getStatusColor(order.status).withOpacity(0.2),
                        ),
                        // Future Feature: Add buttons here to update status
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'shipped': return Colors.blue;
      default: return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Icons.check;
      case 'cancelled': return Icons.close;
      case 'shipped': return Icons.local_shipping;
      default: return Icons.hourglass_top;
    }
  }
}