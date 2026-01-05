import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class HomeViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  // ======================================================
  // 📡 STREAMS (Real-time connection to Database)
  // ======================================================

  // 1. All Products (Grid ke liye)
  Stream<List<ProductModel>> get allProductsStream => _dbService.productsStream;

  // 2. Flash Sale Products (Top Slider ke liye)
  Stream<List<ProductModel>> get flashSaleStream => _dbService.saleProductsStream;

  // ======================================================
  // 🔍 FILTERS (Category & Search)
  // ======================================================

  String _selectedCategory = "All";
  String _searchQuery = "";

  // Getters
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Categories List (For UI Chips: "All", "Sneakers", "Formal"...)
  final List<String> categories = ["All", "Sneakers", "Running", "Formal", "Casual", "Boots"];

  // --- ACTIONS ---

  // 1. Change Category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners(); // UI rebuilds immediately
  }

  // 2. Update Search Text
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // 3. ✨ MASTER FILTER FUNCTION
  // Yeh function raw list leta hai aur usay Filter karke wapis deta hai.
  // Hum isay HomeView ke andar StreamBuilder mein use karenge.
  List<ProductModel> filterProducts(List<ProductModel> products) {
    return products.where((product) {

      // A. Check Category
      bool matchesCategory = _selectedCategory == "All" ||
          product.category == _selectedCategory;

      // B. Check Search Text
      bool matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }
}