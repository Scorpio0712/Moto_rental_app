import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Color(0xFF000AFF),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const ForgotPasswordPage();
                                    }),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildButtonSignIn(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Or Log in using",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildButtonGoogle(),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          GestureDetector(
                            onTap: widget.showRegisterPage,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF000AFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
        constraints: const BoxConstraints.expand(height: 50, width: 150),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: const Color(0xFF2D3250)),
        // margin: EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "Sign in",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        signIn();
      },
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Future signIn() async {
    try {
      final credentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
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
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? user = await googleSignIn.signIn();
      GoogleSignInAuthentication? userAuth = await user!.authentication;

      await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: userAuth.idToken, accessToken: userAuth.accessToken),
      );
      checkAuth(context); // after success route to home.
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kNetworkError) {
        print(
            "A network error (such as timeout, interrupted connection or unreachable host) has occurred.");
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
