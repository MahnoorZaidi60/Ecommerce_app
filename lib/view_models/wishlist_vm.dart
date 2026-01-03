import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WishlistViewModel with ChangeNotifier {
  final List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => _wishlist;

  bool isInWishlist(String id) {
    return _wishlist.any((item) => item.id == id);
  }

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      _wishlist.removeWhere((item) => item.id == product.id);
      Fluttertoast.showToast(msg: "Removed from Wishlist");
    } else {
      _wishlist.add(product);
      Fluttertoast.showToast(msg: "Added to Wishlist");
    }
    notifyListeners();
  }
}