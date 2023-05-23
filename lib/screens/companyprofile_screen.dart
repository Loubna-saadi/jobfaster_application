import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class CompanyProfileScreen extends StatefulWidget {
  static const String screenRoute = 'compabyprofile_screen';

  const CompanyProfileScreen({Key? key}) : super(key: key);

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _specialityController = TextEditingController();

  late User? currentUser;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });

      final userRef = FirebaseFirestore.instance.collection('companies').doc(user.uid);
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
      setState(() {
        userData = snapshot.data() ?? {};
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _cityController.text = userData['city'] ?? '';
        _specialityController.text = userData['speciality'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userRef =
            FirebaseFirestore.instance.collection('companies').doc(user.uid);
        await userRef.set({
          'name': _nameController.text,
          'email': _emailController.text,
          'city': _cityController.text,
          'specialty': _specialityController.text,
        }, SetOptions(merge: true));

        setState(() {
          fetchUserData();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      String profileImageUrl = await uploadProfileImageToStorage(file);
      
      final User? user = _auth.currentUser;
      if (user != null) {
        final userRef =
            FirebaseFirestore.instance.collection('companies').doc(user.uid);
        await userRef.set({
          'profileImage': profileImageUrl,
        }, SetOptions(merge: true));

        setState(() {
          fetchUserData();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    }
  }

  Future<String> uploadProfileImageToStorage(File file) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        final uploadTask = storageRef.putFile(file);
        await uploadTask.whenComplete(() => null);

        final profileImageUrl = await storageRef.getDownloadURL();
        return profileImageUrl;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile picture')),
      );
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (userData.isNotEmpty) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(userData['profileImage'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.blue,
                            width: 4,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Name: ${userData['name'] ?? ''}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${userData['email'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'City: ${userData['city'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Speciality: ${userData['specialty'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      
                    ],
                  ),
      
                ),
              ],
              SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                  cursorColor: Color.fromARGB(255, 53, 68, 128),
                        decoration: InputDecoration(
                          labelText: 'Speciality',
                          floatingLabelStyle:
                              TextStyle(color: Color.fromARGB(255, 53, 68, 128)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 53, 68, 128),
                                width: 2),
                          ),
                        ),
                controller: _specialityController,
               
              ),
              
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfilePicture,
                child: Text('Update Profile Picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




