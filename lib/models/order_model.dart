import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String userName; // ✅ Added: To show name in Admin Panel
  final double totalAmount;
  final String status; // "Pending", "Delivered", "Cancelled"
  final DateTime date;
  final String shippingAddress; // ✅ Added: Crucial for Delivery
  final List<CartItemModel> items;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.shippingAddress,
    required this.items,
  });

  // From Firestore
  factory OrderModel.fromMap(Map<String, dynamic> data, String id) {
    return OrderModel(
      orderId: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown User', // ✅ Safe Default
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      date: (data['date'] as Timestamp).toDate(),
      shippingAddress: data['shippingAddress'] ?? '', // ✅ Retrieving Address

      // Convert List<dynamic> -> List<CartItemModel>
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromMap(item))
          .toList(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName, // ✅ Saving Name
      'totalAmount': totalAmount,
      'status': status,
      'date': Timestamp.fromDate(date),
      'shippingAddress': shippingAddress, // ✅ Saving Address
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}