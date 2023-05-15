// TODO Implement this library.import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> uploadUserData(String name, String familyName, String phone, String email, String imageUrl, String cvUrl) async {
    try {
      await _usersCollection.add({
        'name': name,
        'familyName': familyName,
        'phone': phone,
        'email': email,
        'imageUrl': imageUrl,
        'cvUrl': cvUrl,
      });
    } catch (e) {
      print('Error uploading user data: $e');
      throw e;
    }
  }
}

