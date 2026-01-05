class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // e.g. "Sneakers", "Running", "Formal"
  final bool isSale;     // Appears in "Flash Sale" slider
  final List<String> availableSizes; // ✅ NEW: Essential for Shoes

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.availableSizes, // Required
    this.isSale = false,
  });

  // From Firestore
  factory ProductModel.fromMap(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Sneakers',
      isSale: data['isSale'] ?? false,

      // ✅ Safely converting Firestore List to List<String>
      availableSizes: List<String>.from(data['availableSizes'] ?? []),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isSale': isSale,
      'availableSizes': availableSizes, // ✅ Saving sizes
    };
  }
}