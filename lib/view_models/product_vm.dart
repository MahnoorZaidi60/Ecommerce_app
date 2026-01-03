import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class ProductViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<ProductModel> _allProducts = []; // Master list from DB
  List<ProductModel> _filteredProducts = []; // List shown on UI (after search/filter)

  // Getters
  List<ProductModel> get products => _filteredProducts;

  // Constructor: Start listening to DB immediately
  ProductViewModel() {
    _fetchProducts();
  }

  void _fetchProducts() {
    // Listen to real-time stream
    _dbService.getProducts().listen((productsData) {
      _allProducts = productsData;
      _filteredProducts = productsData; // Initially show all
      notifyListeners();
    });
  }

  // --- FILTER LOGIC ---

  // 1. Search by Name
  void search(String query) {
    if (query.isEmpty) {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // 2. Filter by Category
  void filterByCategory(String category) {
    if (category == "All") {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((p) => p.category == category)
          .toList();
    }
    notifyListeners();
  }
}