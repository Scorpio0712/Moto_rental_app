import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SlipAlert extends StatefulWidget {
  final String orderSelected;
  const SlipAlert({Key? key, required this.orderSelected}) : super(key: key);

  @override
  State<SlipAlert> createState() => _SlipAlertState();
}

class _SlipAlertState extends State<SlipAlert> {
  var imageUrl;
  var imageName;
  final storage = FirebaseStorage.instance;

  Future getData() async {
    try {
      await getImageUrl();
      return imageUrl;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> getImageUrl() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderSelected)
        .get()
        .then((DocumentSnapshot ds) async {
      imageName = ds['slipPayment'];
    });

    final path = 'slips/$imageName';
    final ref = storage.ref().child(path);
    final url = await ref.getDownloadURL();

    imageUrl = url;
    debugPrint(imageUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Slip Payment'),
      content: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Image.network(
                snapshot.data.toString(),
                width: 200,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'Close'),
            child: const Text('Close'))
      ],
    );
  }
}
