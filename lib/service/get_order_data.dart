import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetOrderData extends StatelessWidget {
  final String documentId;
  const GetOrderData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference orderData =
        FirebaseFirestore.instance.collection('orders');

    return GestureDetector(
        child: FutureBuilder<DocumentSnapshot>(
      future: orderData.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${data['nameUser']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Motorcycle: ${data['brandMotor']} ${data['modelMotor']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${data['orderStatus']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          );
        }
        return const Text('Loading...');
      },
    ));
  }
}
