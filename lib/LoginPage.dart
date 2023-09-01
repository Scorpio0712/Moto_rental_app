import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SignUpPage.dart';
import 'HomePage.dart';
import 'ResetPassPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFF2D3250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Logo",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 325,
                height: 525,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: <Widget>[
                        buildTextFieldEmail(),
                        buildTextFieldPassword(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Color(0xFF000AFF),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetPassPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        buildButtonSignIn(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Or Log in using",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildButtonGoogle(),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF000AFF),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                          ),
                        ],
                      ),
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

  Widget buildButtonGoogle() {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 40,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Color(0xFF2D3250),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.google,
                    color: Colors.redAccent)),
            const Text(
              'Login with Google',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onTap: () {
        loginWithGoogle();
      },
    );
  }

  Widget buildButtonSignIn() {
    return InkWell(
      child: Container(
        constraints: BoxConstraints.expand(height: 50, width: 150),
        child: Text(
          "Sign in",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Color(0xFF2D3250)),
        // margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12),
      ),
      onTap: () {
        signIn();
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

  signIn() async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("sign in success ${credentials.user?.email}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'sign in success',
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
      checkAuth(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'No user found for that email.',
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
      } else if (e.code == 'wrong-password') {
        print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Wrong password provided for that user.',
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

  Future checkAuth(context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Already logged in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? user = await googleSignIn.signIn();
      GoogleSignInAuthentication? userAuth = await user!.authentication;

      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: userAuth.idToken, accessToken: userAuth.accessToken),
      );
      checkAuth(context); // after success route to home.
    } on PlatformException catch (e) {
      if( e.code == GoogleSignIn.kNetworkError) {
        print("A network error (such as timeout, interrupted connection or unreachable host) has occurred.");
      } else {
        print("Something went wrong.");
      }
    }
  }

  // buildButtonForgotPassword() {
  //   return InkWell(
  //     child: Container(
  //       constraints: BoxConstraints.expand(height: 50),
  //       child: Text(
  //         "Forgot password",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 18, color: Colors.white),
  //       ),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16), color: Colors.red[300]),
  //       margin: EdgeInsets.only(top: 12),
  //       padding: EdgeInsets.all(12),
  //     ),
  //     onTap: () => navigateToResetPasswordPage(context),
  //   );
  // }

  // navigateToResetPassPage(BuildContext context) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => ResetPassPage()));
  // }
}
