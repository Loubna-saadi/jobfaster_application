import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:jobfaster_application/screens/home.dart';

class TestScreen extends StatefulWidget {
  static const String screenRoute = 'test_screen';

  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _specialtyController = TextEditingController();
  // late File _image;
  File? _image; // Updated line
  File? _cv;

  final picker = ImagePicker();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final familyName = _familyNameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final city = _cityController.text;
      final specialty = _specialtyController.text;

      try {
        // Upload the image to Firebase Storage
        final imageName = DateTime.now().microsecondsSinceEpoch.toString();
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(imageName);
        await storageRef.putFile(_image!);

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();
        // Upload the CV file to Firebase Storage
        final cvName = DateTime.now().microsecondsSinceEpoch.toString();
        final firebase_storage.Reference cvStorageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(cvName);
        await cvStorageRef.putFile(_cv!);

        // Get the download URL of the uploaded CV file
        final cvUrl = await cvStorageRef.getDownloadURL();
        // Store the data in Firestore
        await FirebaseFirestore.instance.collection('test').add({
          'name': name,
          'familyName': familyName,
          'email': email,
          'phone': phone,
          'city': city,
          'specialty': specialty,
          'profileImage': imageUrl,
          'cvFileUrl': cvUrl, // Added line
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully')),
        );

        _nameController.clear();
        _familyNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _cityController.clear();
        _specialtyController.clear();
        Navigator.pushNamed(context, Home.screenRoute);
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

  Future<void> _getCvFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cv = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
        controller: _familyNameController,
        decoration: InputDecoration(
          labelText: 'FamilyName',
        ),
        validator: (value) {
          if (value!.isEmpty) {
        return 'Please enter your family name';
          }
          return null;
        },
      ),SizedBox(height: 20),
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        validator: (value) {
          if (value!.isEmpty) {
        return 'Please enter your email';
          }
          return null;
        },
      ),SizedBox(height: 20),
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
                ),SizedBox(height: 20),
      TextFormField(
        controller: _cityController,
        decoration: InputDecoration(
          labelText: 'City',
        ),
        validator: (value) {
          if (value!.isEmpty) {
        return 'Please enter your city';
          }
          return null;
        },
      ),SizedBox(height: 20),
      TextFormField(
        controller: _specialtyController,
        decoration: InputDecoration(
          labelText: 'Specialty',
        ),
        validator: (value) {
          if (value!.isEmpty) {
        return 'Please enter your specialty';
          }
          return null;
        },
      ),
      
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CV',
                  ),
                  validator: (value) {
                    if (_cv == null) {
                      return 'Please select a CV file';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _getCvFromGallery,
                  child: Text('Select CV'),
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
      ),
    );
  }
}
