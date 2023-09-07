import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMotorData extends StatelessWidget {
  final String documentId;

  const GetMotorData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _motor = FirebaseFirestore.instance.collection('motor');

    return FutureBuilder<DocumentSnapshot>(
      future: _motor.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data['brand'] + ' ' + data['model'],
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        }
        return const Text('Loading...');
      }),
    );
  }
}
