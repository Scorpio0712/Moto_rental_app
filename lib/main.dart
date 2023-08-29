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
      initialRoute: 'main.dart',
      routes: {
        '/log-in': (context) => LoginPage(),
        '/sign-up': (context) => SignUpPage(),
        '/Reset-password': (context) => ResetPassPage(),
        
      },
      home: LoginPage(),
      
    );
    } else {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'main.dart',
      routes: {
        '/log-in': (context) => LoginPage(),
        '/sign-up': (context) => SignUpPage(),
        '/Reset-password': (context) => ResetPassPage(),
      },
      home: HomePage(),
      
    );
    }
  }
}
