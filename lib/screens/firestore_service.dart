// TODO Implement this library.import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _employersCollection =
      FirebaseFirestore.instance.collection('employers');

  Future<void> uploadUserData(String name, String familyName, String phone,
      String email, String imageUrl, String cvUrl) async {
    try {
      await _employersCollection.add({
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
