import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';



class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPassPage();
}

class _ResetPassPage extends State<ResetPassPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

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
                        buildButtonResetPass(),
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

  Widget buildButtonResetPass() {
    return InkWell(
        child: Container(
            constraints: const BoxConstraints.expand(height: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[200]),
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            child: const Text("Reset password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white))),
        onTap: () => resetPassword());
  }

  Container buildTextFieldEmail() {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: emailController,
            decoration: const InputDecoration.collapsed(hintText: "Email"),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 18)));
  }

  resetPassword() {
    final email = emailController.text.trim();
    _auth.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "We send the detail to $email successfully.",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  }
}
