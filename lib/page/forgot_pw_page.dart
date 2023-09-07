import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                'Reset Password',
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
                        buildTextDetail(),
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
        constraints: BoxConstraints.expand(height: 50, width: 200),
        child: Text("Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Color(0xFF2D3250)),
        margin: EdgeInsets.only(top: 14),
        padding: EdgeInsets.all(12),
      ),
      onTap: () {
        resetPassword();
      },
    );
  }

  Container buildTextFieldEmail() {
    return Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffffb17a)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 18)));
  }

  Container buildTextDetail() {
    return Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: const Text(
          "Enter your user account's verified email address and we will send you a password reset link.",
          style: TextStyle(color: Color(0xffffb17a), fontSize: 16),
          textAlign: TextAlign.center,
        ));
  }

  Future resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "We send the detail to $_auth successfully.",
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
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not found',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1500),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      }
    }
  }
}
