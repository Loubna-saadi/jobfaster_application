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
        title: Text('Profile'),
      ),
      body: currentUser != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${userData['name']}'),
                  Text('Email: ${userData['email']}'),
                  Text('City: ${userData['city']}'),
                  Text('Specialty: ${userData['speciality']}'),
                ],
              ),
            )
          : CircularProgressIndicator(),
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

