import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_service.dart';
import 'firestore_service.dart';

class EmployerScreen extends StatefulWidget {
  static const String screenRoute = 'employer_screen';
  const EmployerScreen({Key? key}) : super(key: key);
  @override
  _EmployerScreenState createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late File _image = File(''); // Initialize with an empty file
  late File _cv = File('');
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _familyNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile = await _picker.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<void> _pickCV() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? cvFile = await _picker.pickImage(source: ImageSource.gallery);

    if (cvFile != null) {
      setState(() {
        _cv = File(cvFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_image != null && _cv != null) {
      final String imageName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final String cvName = '${DateTime.now().microsecondsSinceEpoch}.pdf';

      final String imageFolderPath = 'images';
      final String cvFolderPath = 'cv';

      final String imagePath = '$imageFolderPath/$imageName';
      final String cvPath = '$cvFolderPath/$cvName';

      final String? imageUrl =
          await _storageService.uploadFile(_image, imageFolderPath, imageName);
      final String? cvUrl =
          await _storageService.uploadFile(_cv, cvFolderPath, cvName);

      if (imageUrl != null && cvUrl != null) {
        final User? user = _auth.currentUser;
        if (user != null) {
          // final String uid = user.uid;
          final String name = _nameController.text;
          final String familyName = _familyNameController.text;
          final String phone = _phoneController.text;
          final String email = _emailController.text;
          // print(uid);
          final userRef =FirebaseFirestore.instance.collection('test');
      await userRef.doc(user.uid).set({
  'name': name,
  'familyName': familyName,
  'phone': phone,
  'email': email,
  'imageUrl': imageUrl,
  'cvUrl': cvUrl,
});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data uploaded successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not authenticated')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and CV')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _familyNameController,
            decoration: InputDecoration(
              labelText: 'Family Name',
            ),
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          // Center(
          //   child: _image == null ? Text('No image selected') : Image.file(_image),
          // ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Text('Select Image'),
          ),
          SizedBox(height: 20),
          Center(
            child: _cv == null
                ? Text('No CV selected')
                : Text(path.basename(_cv.path)),
          ),
          ElevatedButton(
            onPressed: _pickCV,
            child: Text('Select CV'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadData,
            child: Text('Upload Data'),
          ),
        ],
      ),
    );
  }
}
