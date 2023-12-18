import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ImageUploadService {
  static Future<String?> uploadImage(File imageFile) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Create a unique file name with timestamp
    String fileName = '${timestamp}_${basename(imageFile.path)}';
    Reference storageRef =
        FirebaseStorage.instance.ref().child('post_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    }
    return null;
  }
}
