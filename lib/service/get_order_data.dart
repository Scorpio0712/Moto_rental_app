import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetOrderData extends StatelessWidget {
  final String documentId;
  const GetOrderData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _order =
        FirebaseFirestore.instance.collection('orders');

    return GestureDetector(
        child: FutureBuilder<DocumentSnapshot>(
      future: _order.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text('Order: ' + data['order']),
              Text(
                    data['brandMotor'] +
                    ' ' +
                    data['modelMotor'] +
                    ' ' +
                    data['nameUser'], 
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          );
        }
        return const Text('Loading...');
      },
    ));
  }
}
