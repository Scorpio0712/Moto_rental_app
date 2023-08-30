import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';
import 'ResetPassPage.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if(user == null) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      initialRoute: '/',
      routes: {
        '/sign-up': (context) => const SignUpPage(),
        '/Reset-password': (context) => const ResetPassPage(),
        
      },
      
    );
    } else {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      initialRoute: '/',
      routes: {
        '/log-in': (context) => const LoginPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/Reset-password': (context) => const ResetPassPage(),
      },
      
    );
    }
  }

  // Future checkAuth(BuildContext context) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     print("Already logged in");
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   }
  // }

}
