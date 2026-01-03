import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../view_models/admin_vm.dart';
import '../shared/custom_button.dart';
import '../shared/custom_textfield.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Default Category
  String _selectedCategory = "Electronics";
  bool _isSale = false;
  final List<String> _categories = ["Electronics", "Fashion", "Home", "Beauty", "Sports"];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminVM = Provider.of<AdminViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Image Picker Box
              GestureDetector(
                onTap: () => adminVM.pickImage(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: adminVM.selectedImage == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                      Text("Tap to select image"),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    // Logic to show image on Web vs Mobile
                    child: kIsWeb
                        ? Image.network(adminVM.selectedImage!.path, fit: BoxFit.cover)
                        : Image.file(File(adminVM.selectedImage!.path), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Name
              CustomTextField(
                controller: _nameController,
                label: "Product Name",
                hint: "e.g. iPhone 15",
                validator: AppValidators.validateName,
              ),

              // 3. Price
              CustomTextField(
                controller: _priceController,
                label: "Price",
                hint: "e.g. 150000",
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter price";
                  if (double.tryParse(val) == null) return "Enter valid number";
                  return null;
                },
              ),

              // 4. Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ 5. NEW: Flash Sale Switch
              SwitchListTile(
                title: const Text("Put on Flash Sale?"),
                subtitle: const Text("Item will appear in the top slider"),
                value: _isSale,
                activeColor: Colors.red, // Red to show urgency
                onChanged: (val) {
                  setState(() => _isSale = val);
                },
              ),
              const SizedBox(height: 16),

              // 6. Description (Same as before)
              CustomTextField(
                controller: _descController,
                label: "Description",
                hint: "Enter details...",
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "Enter description" : null,
              ),

              const SizedBox(height: 30),

              // 7. Button Update
              CustomButton(
                text: "Upload Product",
                isLoading: adminVM.isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    adminVM.uploadProduct(
                      name: _nameController.text.trim(),
                      desc: _descController.text.trim(),
                      priceStr: _priceController.text.trim(),
                      category: _selectedCategory,
                      isSale: _isSale, // ✅ Pass the switch value
                      context: context,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}