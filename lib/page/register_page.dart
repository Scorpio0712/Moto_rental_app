import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: const Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                    ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextFieldFirstName(), // first name text field
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextFieldLastName(), // last name text field
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextFieldEmail(), // email text field
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextFieldPassword(), // password text field
                        const SizedBox(
                          height: 10,
                        ),
                        buildTextFieldConfirmPassword(), // confirm password text field
                        const SizedBox(
                          height: 10,
                        ),
                        buildButtonSignUp(), // sign up button
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonSignUp() {
    return GestureDetector(
      onTap: signUp,
      child: Container(
        constraints: const BoxConstraints.expand(height: 50, width: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF2D3250),
        ),
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Container buildTextFieldLastName() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
          hintText: "Last Name",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldFirstName() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
          hintText: "First Name",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          hintText: "Email",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldConfirmPassword() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _confirmController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Confirm Password",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  bool passwordConfirm() {
    if (_passwordController == _confirmController &&
        _passwordController.text.length >= 6) {
      return true;
      } else if (_passwordController == _confirmController &&
          _passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Password must be at least 6 characters',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.yellowAccent,
          duration: const Duration(milliseconds: 1500),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
        return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        ),
      );
      return false;
    }
  }

  Future signUp() async {
    if (passwordConfirm()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        ),
      );
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }
}
