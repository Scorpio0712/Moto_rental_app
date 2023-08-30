import 'package:carrental_app/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFF676F9D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // SizedBox(width: 20),
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 325,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: <Widget>[
                        buildTextFieldEmail(),
                        buildTextFieldPassword(),
                        buildTextFieldConfirmPassword(),
                        buildButtonSignUp(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ],
        ),
      ),
    );
  }

  Widget buildButtonSignUp() {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50, width: 150),
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Color(0xFF2D3250)),
        margin: EdgeInsets.only(top: 14),
        padding: EdgeInsets.all(12),
      ),
      onTap: () {
        signUp();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      },
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldConfirmPassword() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: confirmController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Confirm Password",
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmController.text.trim();
    if (password == confirmPassword && password.length >= 6) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print("Sign up user successful.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Sign up user successful.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 1500),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
      }).catchError((error) {
        print(error.message);
      });
    } else {
      print("Password and Confirm-password is not match.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Password and Confirm-password is not match.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 1500),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    }
  }
}
