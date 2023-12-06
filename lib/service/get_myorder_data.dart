import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMyOrderData extends StatelessWidget {
  final String documentId;
  const GetMyOrderData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference myOrderData =
        FirebaseFirestore.instance.collection('orders');

    return GestureDetector(
        child: FutureBuilder<DocumentSnapshot>(
      future: myOrderData.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['orderStatus'] == 'problem') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${data['nameUser']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      'Motorcycle: ${data['brandMotor']} ${data['modelMotor']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${data['orderStatus']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                )
              ],
            );
          } else if (data['orderStatus'] == 'success') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${data['nameUser']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                    Text(
                      'Motorcycle: ${data['brandMotor']} ${data['modelMotor']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${data['orderStatus']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
