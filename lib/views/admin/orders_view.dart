import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/database_service.dart';

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
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final dateStr = "${order.date.day}/${order.date.month}/${order.date.year}"; // Simple Date

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // Header Icon
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getStatusIcon(order.status), color: _getStatusColor(order.status), size: 20),
                ),

                // Title
                title: Text(
                  "Order #${order.orderId.substring(0, 5).toUpperCase()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // Subtitle
                subtitle: Text("$dateStr • ${order.userName}"),

                // Amount
                trailing: Text(
                  "Rs. ${order.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                // Details Body
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Shipping Address
                        const Text("DELIVERY ADDRESS:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text(order.shippingAddress, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),

                        // 2. Items List
                        const Text("ITEMS:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${item.quantity}x ${item.name} (${item.selectedSize})"),
                              Text("Rs. ${item.price * item.quantity}"),
                            ],
                          ),
                        )),

                        const SizedBox(height: 20),

                        // 3. ADMIN ACTION BUTTONS
                        if (order.status == "Pending")
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                dbService.updateOrderStatus(order.orderId, "Delivered");
                              },
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text("MARK AS DELIVERED"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Order is ${order.status}",
                              style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.bold),
                            ),
                          ),
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
      default: return Colors.orange; // Pending
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Icons.check;
      case 'cancelled': return Icons.close;
      case 'shipped': return Icons.local_shipping;
      default: return Icons.hourglass_top; // Pending
    }
  }
}