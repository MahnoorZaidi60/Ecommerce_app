class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String selectedSize; // ✅ Added: Essential for Shoes (e.g., "US 9")
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.selectedSize, // Required now
    this.quantity = 1,
  });

  // Helper to calculate total
  double get total => price * quantity;

  // Convert to Map (For Firestore Order)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'selectedSize': selectedSize, // ✅ Saving Size
    };
  }

  // From Map (For History)
  factory CartItemModel.fromMap(Map<String, dynamic> data) {
    return CartItemModel(
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
      selectedSize: data['selectedSize'] ?? 'US 8', // ✅ Retrieving Size
    );
  }
}