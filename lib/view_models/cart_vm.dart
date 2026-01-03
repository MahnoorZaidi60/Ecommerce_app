import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class CartViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();

  // Internal Cart Storage (ProductId -> CartItem)
  final Map<String, CartItemModel> _cartItems = {};

  // Getters
  Map<String, CartItemModel> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // --- ACTIONS ---

  void addToCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      // If already in cart, increase quantity
      _cartItems.update(
        product.id,
            (existing) => CartItemModel(
          productId: existing.productId,
          name: existing.name,
          imageUrl: existing.imageUrl,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      // Add new item
      _cartItems.putIfAbsent(
        product.id,
            () => CartItemModel(
          productId: product.id,
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    Fluttertoast.showToast(msg: "Added to Cart");
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // --- CHECKOUT ---

  bool _isPlacingOrder = false;
  bool get isPlacingOrder => _isPlacingOrder;

  Future<void> placeOrder(BuildContext context) async {
    final user = _authService.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: "Please login to place order");
      return;
    }

    if (_cartItems.isEmpty) {
      Fluttertoast.showToast(msg: "Cart is empty");
      return;
    }

    _isPlacingOrder = true;
    notifyListeners();

    try {
      // Create Order Object
      final order = OrderModel(
        orderId: '', // Firebase will generate ID
        userId: user.uid,
        totalAmount: totalAmount,
        status: "Pending",
        date: DateTime.now(),
        items: _cartItems.values.toList(),
      );

      // Send to Firebase
      await _dbService.placeOrder(order);

      clearCart(); // Empty cart locally
      Fluttertoast.showToast(msg: "Order Placed Successfully!");

      if(context.mounted) {
        Navigator.pop(context); // Close checkout screen
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to place order: $e");
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }
}