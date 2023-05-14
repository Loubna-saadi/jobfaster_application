import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String?> uploadFile(File file) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = _storage.ref().child('files/$fileName');
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading file: $e');
    return null;
  }
}


  Future<void> deleteFile(String fileUrl) async {
    try {
      Reference reference = _storage.refFromURL(fileUrl);
      await reference.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
