import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Added for User ID
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // ✅ Auth Instance

  // Collection References
  CollectionReference get _productsRef => _db.collection('products');
  CollectionReference get _ordersRef => _db.collection('orders');

  // ======================================================
  // 👟 1. PRODUCTS (SHOES)
  // ======================================================

  // A. Add Product (Admin)
  Future<void> addProduct(ProductModel product) async {
    DocumentReference docRef = _productsRef.doc(); // Generate ID

    ProductModel newProduct = ProductModel(
      id: docRef.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      availableSizes: product.availableSizes,
      isSale: product.isSale,
    );

    await docRef.set(newProduct.toMap());
  }

  // B. Delete Product
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  // C. Stream ALL Products (For Shop Page)
  Stream<List<ProductModel>> get productsStream {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // D. Stream FLASH SALE Products (For Home Slider)
  Stream<List<ProductModel>> get saleProductsStream {
    return _productsRef.where('isSale', isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // ======================================================
  // 📦 2. ORDERS (Checkout & Admin)
  // ======================================================

  // A. Place Order
  Future<void> placeOrder({
    required String userId,
    required String userName,
    required String address,
    required double total,
    required List<CartItemModel> items,
  }) async {
    DocumentReference docRef = _ordersRef.doc();

    OrderModel newOrder = OrderModel(
      orderId: docRef.id,
      userId: userId,
      userName: userName,
      totalAmount: total,
      status: "Pending",
      date: DateTime.now(),
      shippingAddress: address,
      items: items,
    );

    await docRef.set(newOrder.toMap());
  }

  // B. Get My Orders (User History) - ✅ FIXED
  Stream<List<OrderModel>> getUserOrders() {
    try {
      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        return Stream.value([]);
      }

      // Note: Maine orderBy hata diya hai taake Index error na aaye.
      return _ordersRef
          .where('userId', isEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });

    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user orders: $e");
      return Stream.value([]);
    }
  }

  // C. Get ALL Orders (Admin Dashboard)
  Stream<List<OrderModel>> getAllOrders() {
    return _ordersRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // D. Update Order Status (Admin Feature)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _ordersRef.doc(orderId).update({'status': newStatus});
  }
}