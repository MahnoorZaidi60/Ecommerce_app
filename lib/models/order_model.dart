import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final double totalAmount;
  final String status; // e.g., "Pending", "Delivered"
  final DateTime date;
  final List<CartItemModel> items;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.items,
  });

  // From Firestore
  factory OrderModel.fromMap(Map<String, dynamic> data, String id) {
    return OrderModel(
      orderId: id,
      userId: data['userId'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      // Convert Timestamp to DateTime
      date: (data['date'] as Timestamp).toDate(),
      // Convert List<dynamic> to List<CartItemModel>
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromMap(item))
          .toList(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'date': Timestamp.fromDate(date),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}