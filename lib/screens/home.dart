// ignore_for_file: prefer_const_constructors

// import 'package:flatemate/screens/flat_screen.dart';
// import 'package:flatemate/screens/flatmate_screen.dart';
// import 'package:flatemate/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  //const Home({super.key});
  static const String screenRoute = 'home_screen';

  const Home({super.key});

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
          title: Text('Flatmate'),
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
              print(signedInUser.email);
            },
          ),
          toolbarHeight: 65,
          backgroundColor: Color(0xFFF65A83), //Color(0xFFF44336)
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                onPressed: () {
                  // _auth.signOut();
                  // Navigator.pushReplacementNamed(
                  //     context, WelcomeScreen.screenRoute);
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
                text: 'flats',
              ),
              Tab(
                icon: Icon(Icons.groups),
                text: 'flatmates',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            // FlatScreen(),
            // FlatmateScreen(),
          ],
        ),
      ),
    );
  }
}
