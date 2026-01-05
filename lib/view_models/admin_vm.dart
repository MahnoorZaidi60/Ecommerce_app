import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class AdminViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String? _base64Image; // Image string store karne ke liye

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // 📸 PICK IMAGE (Updated Quality Settings)
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // ✅ BALANCE SETTINGS:
        maxWidth: 800,    // Width limit (Mobile ke liye 800px HD hota hai)
        maxHeight: 800,   // Height limit
        imageQuality: 70, // Quality 70% (Clear dikhegi, par size control mein rahega)
      );

      if (image != null) {
        _selectedImage = File(image.path);

        // Convert Image to Base64 String immediately
        List<int> imageBytes = await _selectedImage!.readAsBytes();
        _base64Image = base64Encode(imageBytes);

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Image Pick Error: $e");
      Fluttertoast.showToast(msg: "Failed to pick image");
    }
  }

  // 📤 UPLOAD PRODUCT
  Future<void> uploadProduct({
    required String name,
    required String desc,
    required String priceStr,
    required String category,
    required bool isSale,
    required BuildContext context,
  }) async {
    if (_base64Image == null) {
      Fluttertoast.showToast(msg: "Please select an image first!", backgroundColor: Colors.red);
      return;
    }

    setLoading(true);

    try {
      final double price = double.parse(priceStr);

      // Create Product Model
      ProductModel newProduct = ProductModel(
        id: "", // ID DB service mein generate hogi
        name: name,
        description: desc,
        price: price,
        imageUrl: _base64Image!, // High Quality String
        category: category,
        isSale: isSale,
        availableSizes: _selectedSizes.toList(), // List Convert
      );

      await _dbService.addProduct(newProduct);

      setLoading(false);
      Fluttertoast.showToast(msg: "Shoe Uploaded Successfully!");

      // Clear Form
      clearForm();

      if (context.mounted) Navigator.pop(context);

    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(msg: "Upload Failed: $e", backgroundColor: Colors.red);
    }
  }

  // 🧹 CLEAR FORM
  void clearForm() {
    _selectedImage = null;
    _base64Image = null;
    _selectedSizes.clear();
    notifyListeners();
  }

  // 👟 SIZE SELECTION LOGIC
  final List<String> allSizes = ["US 6", "US 7", "US 8", "US 9", "US 10", "US 11", "US 12"];
  final Set<String> _selectedSizes = {};
  List<String> get selectedSizes => _selectedSizes.toList();

  void toggleSize(String size) {
    if (_selectedSizes.contains(size)) {
      _selectedSizes.remove(size);
    } else {
      _selectedSizes.add(size);
    }
    notifyListeners();
  }

  // 🗑️ DELETE PRODUCT
  Future<void> deleteProduct(String id) async {
    try {
      await _dbService.deleteProduct(id);
      Fluttertoast.showToast(msg: "Product Deleted");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting product");
    }
  }
}