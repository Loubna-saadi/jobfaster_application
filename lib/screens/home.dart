import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobfaster_application/screens/welcome_screen.dart';

import 'Profile_screen.dart';

class Home extends StatefulWidget {
  static const String screenRoute = 'home_screen';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  late User signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
      for (final userInfo in user!.providerData) {
        if (userInfo.providerId == 'google.com') {
          signedInUser = user;
          break;
        }
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
                colors: const [Color(0xFFF65A83), Color(0xFF293462)],
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
              // Redirect to profile screen
              Navigator.pushNamed(context, ProfileScreen.screenRoute);
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
                  Navigator.pushReplacementNamed(
                      context, WelcomeScreen.screenRoutes);
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
                text: 'employers',
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
