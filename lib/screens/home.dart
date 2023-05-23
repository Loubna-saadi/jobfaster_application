import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfaster_application/screens/welcome_screen.dart';
import 'package:jobfaster_application/screens/profile_screen.dart';
import 'package:jobfaster_application/screens/test_screen.dart';

import 'companyprofile_screen.dart';

class Home extends StatefulWidget {
  static const String screenRoute = 'home_screen';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  late User? signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          signedInUser = user;
        });
        print(signedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('jobfaster'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          leading: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Icon(Icons.account_circle),
            ),
            onTap: () {
              // Redirect to profile screen based on role
              if (signedInUser != null) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(signedInUser!.uid)
                    .get()
                    .then((snapshot) {
                  if (snapshot.exists) {
                    final userData = snapshot.data() as Map<String, dynamic>;
                    final role = userData['role'];
                    if (role == 'company') {
                      Navigator.pushNamed(context, CompanyProfileScreen.screenRoute);
                    } else {
                      Navigator.pushNamed(context, ProfileScreen.screenRoute);
                    }
                  }
                });
              }
            },
          ),
          toolbarHeight: 65,
          backgroundColor: Color(0xFFF65A83),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacementNamed(context, WelcomeScreen.screenRoutes);
                },
                icon: Icon(Icons.logout),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.apartment),
                text: 'jobs',
              ),
              Tab(
                icon: Icon(Icons.groups),
                text: 'employees',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            // jobsscreen(),
            // employerslist(),
          ],
        ),
      ),
    );
  }
}
