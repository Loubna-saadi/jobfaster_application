import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User? currentUser;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });

      final userRef = FirebaseFirestore.instance.collection('test').doc(user.uid);
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        print('Snapshot data: ${snapshot.data()}');
        setState(() {
          userData = snapshot.data() ?? {};
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 139, 124, 247),
                Color(0xFF1BAFAF),
              ],
            ),
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: currentUser != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Specialty: ${userData['specialty'] ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
























// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   static const String screenRoute = 'profile_screen';

//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _specialityController = TextEditingController();

//   late User? currentUser;
//   late Map<String, dynamic> userData;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUser = user;
//       });

//       final userRef = FirebaseFirestore.instance.collection('test').doc(user.uid);
//       final DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
//       userData = snapshot.data()!;

//       setState(() {
//         _nameController.text = userData['name'];
//         _emailController.text = userData['email'];
//         _cityController.text = userData['city'];
//         _specialityController.text = userData['speciality'];
//       });
//     }
//   }

//   Future<void> _updateProfile() async {
//   try {
//     final User? user = _auth.currentUser;
//     if (user != null) {
//       final userRef =
//           FirebaseFirestore.instance.collection('test').doc(user.uid);
//       await userRef.set({
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'city': _cityController.text,
//         'speciality': _specialityController.text,
//       }, SetOptions(merge: true));

//       setState(() {
//         userData = userRef.get() as Map<String, dynamic>;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile updated successfully')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error updating profile')),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _cityController,
//               decoration: InputDecoration(labelText: 'City'),
//             ),
//             TextField(
//               controller: _specialityController,
//               decoration: InputDecoration(labelText: 'Speciality'),
//             ),
//             ElevatedButton(
//               onPressed: _updateProfile,
//               child: Text('Update Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

