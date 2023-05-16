import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TestScreen extends StatefulWidget {
  static const String screenRoute = 'test_screen';

  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  // late File _image;
  File? _image; // Updated line
 
  final picker = ImagePicker();

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final name = _nameController.text;
    final phone = _phoneController.text;

    try {
      // Upload the image to Firebase Storage
      final imageName = DateTime.now().microsecondsSinceEpoch.toString();
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(imageName);
      await storageRef.putFile(_image!);

      // Get the download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Store the data in Firestore
      await FirebaseFirestore.instance.collection('test').add({
        'name': name,
        'phone': phone,
        'profileImage': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data submitted successfully')),
      );

      _nameController.clear();
      _phoneController.clear();
    } catch (e) {
      print(e.toString()); // Print the error message to the console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting data')),
      );
    }
  }
}

Future<void> _getImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _getImageFromGallery,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 40,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
