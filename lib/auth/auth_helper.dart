import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signUpWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken, idToken: auth?.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  static logOut() {
    GoogleSignIn().signOut();
    return _auth.signOut();
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User? user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "name": user?.displayName,
      "email": user?.email,
      "role": "user",
      "build_number": buildNumber,
    };
    await _db.collection("users").doc(user?.uid).set(userData);
  }
}
