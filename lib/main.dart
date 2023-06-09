import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jobfaster_application/screens/registration_screen.dart';
import 'package:jobfaster_application/screens/signin_screen.dart';
import 'package:jobfaster_application/screens/identity_screen.dart';
import 'package:jobfaster_application/widgets/apply_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:jobfaster_application/screens/employer_screen.dart';
import 'package:jobfaster_application/screens/test_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobfaster_application/screens/profile_screen.dart';
import 'package:jobfaster_application/screens/companyinfo_screen.dart';
import 'package:jobfaster_application/screens/companyprofile_screen.dart';
import 'package:jobfaster_application/screens/joboffer_screen.dart';
import 'package:jobfaster_application/screens/applications_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FlutterDownloader.initialize(
    debug: true // Set to false in release mode
  );
  await Firebase.initializeApp();

  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessageMe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: WelcomeScreen(),
      initialRoute: WelcomeScreen.screenRoutes,
      routes: {
        WelcomeScreen.screenRoutes: (context) => const WelcomeScreen(),
        SignInScreen.screenRoutes: (context) => const SignInScreen(),
        RegistrationScreen.screenRoutes: (context) =>
            const RegistrationScreen(),
        Home.screenRoute: (context) => const Home(),
        IdentityScreen.screenRoute: (context) => const IdentityScreen(),
        EmployerScreen.screenRoute: (context) => const EmployerScreen(),
        TestScreen.screenRoute: (context) => const TestScreen(),
        ProfileScreen.screenRoute: (context) => const ProfileScreen(),
        CompanyInfoScreen.screenRoute: (context) => const CompanyInfoScreen(),
        CompanyProfileScreen.screenRoute: (context) =>
            const CompanyProfileScreen(),
        JobOfferScreen.screenRoute: (context) => const JobOfferScreen(),
        ApplicationsScreen.screenRoute: (context) => ApplicationsScreen(),
        ApplyScreen.screenRoute: (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final jobOffer = args['jobOffer'] as Map<String, dynamic>;
          final jobId = args['jobId'] as String;
          final companyId = args['companyId'] as String;
          return ApplyScreen(
            jobOffer: jobOffer,
            jobId: jobId,
            companyId: companyId,
          );
        },
      },
    );
  }
}
