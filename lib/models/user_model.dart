class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String address;
  final bool isAdmin; // ✅ Added: To identify Admin users

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone = '',
    this.address = '',
    this.isAdmin = false, // Default is user
  });

  // Convert Firebase Document to User Object
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      isAdmin: data['isAdmin'] ?? false, // ✅ Retrieve Role
    );
  }

  // Convert User Object to Map (for uploading)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'isAdmin': isAdmin, // ✅ Save Role
    };
  }
}