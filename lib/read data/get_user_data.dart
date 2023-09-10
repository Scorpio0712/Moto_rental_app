import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserData extends StatelessWidget {
  final checkUser = FirebaseAuth.instance.currentUser;
  final String documentId;
  GetUserData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _user = FirebaseFirestore.instance.collection('users');

    return FutureBuilder(
      future: _user.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (checkUser?.email == data['email']) {
            return Text(
              data['name'],
              style: const TextStyle(color: Color(0xffffb17a)),
            );
          }
        }
        return const Text('Loading...');
      },
    );
  }
}
