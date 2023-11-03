import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMotorData extends StatelessWidget {
  final String documentId;

  const GetMotorData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _motor = FirebaseFirestore.instance.collection('motor');

    return GestureDetector(
        child: FutureBuilder<DocumentSnapshot>(
      future: _motor.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text(
                data['brand'] + ' ' + data['model'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Motor amount: ${data['amount']}'),
            ],
          );
        }
        return const Text('Loading...');
      },
    ));
  }
}
