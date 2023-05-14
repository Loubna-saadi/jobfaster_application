import 'package:flutter/material.dart';
import 'package:jobfaster_application/screens/registration_screen.dart';
import 'package:jobfaster_application/screens/signin_screen.dart';
import '../widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoutes = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16113A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Image.asset('images/logo.PNG'),
                ),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 139, 124, 247),
                        Color(0xFFC4F6F6),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'jobfaster',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Set the initial color to white
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            MyButton(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              title: 'Sign in',
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoutes);
              },
            ),
            MyButton(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoutes);
              },
            ),
          ],
        ),
      ),
    );
  }
}
