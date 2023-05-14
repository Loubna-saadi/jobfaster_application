// TODO Implement this library.import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> uploadUserData(String name, String imageUrl, String cvUrl) async {
    try {
      await _usersCollection.add({
        'name': name,
        'image_url': imageUrl,
        'cv_url': cvUrl,
      });
    } catch (e) {
      print('Error uploading user data: $e');
    }
  }
}
