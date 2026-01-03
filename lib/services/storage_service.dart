import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload Image (Works for Web & Mobile)
  Future<String> uploadImage(XFile file, String folder) async {
    try {
      // 1. Generate unique filename
      String fileName = const Uuid().v4();

      // 2. Create Reference
      Reference ref = _storage.ref().child('$folder/$fileName.jpg');

      // 3. Convert to Bytes (Safe for Web & Mobile)
      Uint8List data = await file.readAsBytes();

      // 4. Upload
      UploadTask uploadTask = ref.putData(data, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await uploadTask;

      // 5. Get URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw "Image Upload Failed: $e";
    }
  }
}