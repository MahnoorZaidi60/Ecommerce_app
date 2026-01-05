import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';

class OrderViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  // ======================================================
  // 👤 USER SIDE: My Order History
  // ======================================================
  Stream<List<OrderModel>> get myOrdersStream {
    // ✅ Change: Ab humein ID pass karne ki zaroorat nahi,
    // DatabaseService khud handle karega.
    return _dbService.getUserOrders();
  }

  // ======================================================
  // 👑 ADMIN SIDE: All Orders Dashboard
  // ======================================================
  Stream<List<OrderModel>> get allOrdersStream {
    return _dbService.getAllOrders();
  }

  // Admin: Update Status (Pending -> Delivered)
  Future<void> updateStatus(String orderId, String newStatus) async {
    await _dbService.updateOrderStatus(orderId, newStatus);
  }
}