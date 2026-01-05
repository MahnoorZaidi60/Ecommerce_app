import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../core/utils/routes.dart';

class CartViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🛒 Internal Storage: LIST is better for Sizes (Map is hard for composite keys)
  final List<CartItemModel> _cartItems = [];

  // Getters
  List<CartItemModel> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // ======================================================
  // 👟 CART ACTIONS (Handle Shoe Sizes)
  // ======================================================

  void addToCart(ProductModel product, String selectedSize) {
    // Check: Kya yeh Product ID + Yeh Size pehle se hai?
    int index = _cartItems.indexWhere((item) =>
    item.productId == product.id && item.selectedSize == selectedSize);

    if (index >= 0) {
      // ✅ Agar hai, Quantity barha do
      _cartItems[index].quantity++;
    } else {
      // 🆕 Agar nahi, Naya Item add karo
      _cartItems.add(CartItemModel(
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        selectedSize: selectedSize, // Saving Size
        quantity: 1,
      ));
    }

    notifyListeners();
    Fluttertoast.showToast(msg: "Added to Cart (Size: $selectedSize)");
  }

  void removeFromCart(CartItemModel item) {
    // Remove specific item (ID + Size match)
    _cartItems.removeWhere((element) =>
    element.productId == item.productId && element.selectedSize == item.selectedSize);
    notifyListeners();
  }

  void decreaseQuantity(CartItemModel item) {
    int index = _cartItems.indexOf(item);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index); // 0 hua toh uda do
      }
      notifyListeners();
    }
  }

  void increaseQuantity(CartItemModel item) {
    int index = _cartItems.indexOf(item);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ======================================================
  // 📦 CHECKOUT (Place Order)
  // ======================================================

  bool _isPlacingOrder = false;
  bool get isPlacingOrder => _isPlacingOrder;

  Future<void> placeOrder(BuildContext context, String shippingAddress) async {
    final user = _auth.currentUser;

    // Validations
    if (user == null) {
      Fluttertoast.showToast(msg: "Please login to place order");
      return;
    }
    if (_cartItems.isEmpty) {
      Fluttertoast.showToast(msg: "Cart is empty");
      return;
    }
    if (shippingAddress.isEmpty || shippingAddress.length < 5) {
      Fluttertoast.showToast(msg: "Please enter a valid address");
      return;
    }

    _isPlacingOrder = true;
    notifyListeners();

    try {
      // 1. Send Order to Database
      await _dbService.placeOrder(
        userId: user.uid,
        userName: user.email?.split('@')[0] ?? "User", // Email ka pehla hissa as Name
        address: shippingAddress,
        total: totalAmount,
        items: _cartItems,
      );

      // 2. Success Logic
      clearCart();
      Fluttertoast.showToast(msg: "Order Placed Successfully!");

      if (context.mounted) {
        // Go back to Home or Order History
        Navigator.popUntil(context, (route) => route.isFirst);
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Failed: $e");
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }
}