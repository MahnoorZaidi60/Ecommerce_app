import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminViewModel with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  // 1. Pick Image (Works on Web & Mobile)
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = image;
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  // 2. Upload Product
// Update this function signature
  Future<void> uploadProduct({
    required String name,
    required String desc,
    required String priceStr,
    required String category,
    required bool isSale, // ✅ Add this parameter
    required BuildContext context,
  }) async {

    if (_selectedImage == null) {
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = await _storageService.uploadImage(_selectedImage!, 'products');

      ProductModel newProduct = ProductModel(
        id: '',
        name: name,
        description: desc,
        price: double.tryParse(priceStr) ?? 0.0,
        imageUrl: imageUrl,
        category: category,
        isSale: isSale, // ✅ Pass logic here
      );

      await _dbService.addProduct(newProduct);

      Fluttertoast.showToast(msg: "Product Uploaded!");
      clearImage();
      if(context.mounted) Navigator.pop(context);

    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Delete Product
  Future<void> deleteProduct(String id) async {
    try {
      await _dbService.deleteProduct(id);
      Fluttertoast.showToast(msg: "Product Deleted");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}