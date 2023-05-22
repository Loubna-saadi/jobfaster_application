// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:jobfaster_application/screens/student_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobfaster_application/screens/test_screen.dart';

import 'companyinfo_screen.dart';

class IdentityScreen extends StatefulWidget {
  static const String screenRoute = 'identity_screen';
  const IdentityScreen({Key? key}) : super(key: key);

  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:const [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // _auth.signOut();
              // Navigator.pushReplacementNamed(
              //     context, WelcomeScreen.screenRoute);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Color(0xFF16113A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 100, 10, 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, TestScreen.screenRoute);
                  },
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        elevation: 20,
                        shadowColor: Color.fromARGB(255, 139, 124, 247),
                        child: Container(
                          width: 280,
                          height: 150,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              colors:[Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 70.0,
                            child: Image.asset('images/job-search.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'I\'m an employer',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 244, 245, 246),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 100),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CompanyInfoScreen.screenRoute);
                  },
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        elevation: 20,
                        shadowColor: Color.fromARGB(255, 139, 124, 247),
                        child: Container(
                          width: 280,
                          height: 150,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 70.0,
                            child: Image.asset('images/company.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'company',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 252, 253, 253),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
