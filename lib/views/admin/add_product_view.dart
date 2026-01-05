import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../view_models/admin_vm.dart';

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

  // Shoe Categories
  String _selectedCategory = "Sneakers";
  final List<String> _categories = ["Sneakers", "Running", "Formal", "Casual", "Boots", "Loafers"];

  bool _isSale = false;

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

    // 🎨 Theme Logic
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final inputFillColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    // Common Input Decoration
    InputDecoration inputDeco(String label, String hint) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: textColor),
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Upload New Shoe", style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. IMAGE PICKER
              GestureDetector(
                onTap: () => adminVM.pickImage(),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                  child: adminVM.selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded, size: 50, color: hintColor),
                      const SizedBox(height: 10),
                      Text("Tap to add Shoe Image", style: TextStyle(color: hintColor)),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      adminVM.selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. NAME
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: textColor),
                decoration: inputDeco("Shoe Name", "e.g. Nike Air Max"),
                validator: (val) => val!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 16),

              // 3. PRICE
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: inputDeco("Price (PKR)", "e.g. 12000"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter price";
                  if (double.tryParse(val) == null) return "Enter valid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. CATEGORY DROPDOWN
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                style: TextStyle(color: textColor),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: TextStyle(color: textColor))
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: inputDeco("Category", ""),
              ),
              const SizedBox(height: 20),

              // 5. SIZE SELECTION
              Text(
                  "Select Available Sizes:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: adminVM.allSizes.map((size) {
                  final isSelected = adminVM.selectedSizes.contains(size);
                  return ChoiceChip(
                    label: Text(size),
                    selected: isSelected,
                    selectedColor: isDark ? Colors.white : Colors.black,
                    backgroundColor: isDark ? Colors.black : Colors.grey[100],
                    labelStyle: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : textColor,
                        fontWeight: FontWeight.bold
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
                      ),
                    ),
                    onSelected: (_) => adminVM.toggleSize(size),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 6. 🔴 FLASH SALE SWITCH (Fixed Color)
              Container(
                decoration: BoxDecoration(
                  color: inputFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text("Flash Sale Item?", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  subtitle: Text("Highlight on Home Slider", style: TextStyle(color: hintColor, fontSize: 12)),
                  value: _isSale,

                  // ✅ RED COLORS (Dono Modes mein Red)
                  activeColor: Colors.red,
                  activeTrackColor: Colors.red.withOpacity(0.4),

                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,

                  onChanged: (val) => setState(() => _isSale = val),
                ),
              ),
              const SizedBox(height: 10),

              // 7. DESCRIPTION
              TextFormField(
                controller: _descController,
                maxLines: 4,
                style: TextStyle(color: textColor),
                decoration: inputDeco("Description", "Enter details..."),
                validator: (val) => val!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 30),

              // 8. UPLOAD BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                  ),
                  onPressed: adminVM.isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      adminVM.uploadProduct(
                        name: _nameController.text.trim(),
                        desc: _descController.text.trim(),
                        priceStr: _priceController.text.trim(),
                        category: _selectedCategory,
                        isSale: _isSale,
                        context: context,
                      );
                    }
                  },
                  child: adminVM.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("UPLOAD SHOE", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}