import 'package:carrental_app/auth/auth_check.dart';
import 'package:carrental_app/auth/auth_helper.dart';
import 'package:carrental_app/page/admin/admin_home_page.dart';
import 'package:carrental_app/page/user/check_name_page.dart';
import 'package:carrental_app/page/user/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          UserHelper.saveUser(snapshot.data);
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(snapshot.data!.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                final user = snapshot.data!;
                final userName = user['name'];
                final userRole = user['role'];
                if (userRole == 'admin') {
                  return const AdminHomePage();
                } else if (userName != null) {
                  return const HomePage();
                } else {
                  return const CheckNameUserPage();
                }
              }
            },
          );
        }
        return const AuthPage();
      },
    );
  }
}
