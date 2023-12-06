import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GetMotorData extends StatelessWidget {
  final String documentId;
  var imageName;
  var imageUrl;

  GetMotorData({super.key, required this.documentId});

  Future<void> getImageUrl() async {
    await FirebaseFirestore.instance
        .collection('motor')
        .doc(documentId)
        .get()
        .then((DocumentSnapshot ds) async {
      imageName = ds['picMotor'];
    });

    final path = 'motor/$imageName';
    final ref = FirebaseStorage.instance.ref().child(path);
    final url = await ref.getDownloadURL();

    imageUrl = url;
    debugPrint(imageUrl.toString());
  }

  Future getImageData() async {
    try {
      await getImageUrl();
      return imageUrl;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference motor = FirebaseFirestore.instance.collection('motor');

    return Container(
      padding: const EdgeInsets.all(5.0),
      height: 150,
      child: Card(
        color: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: getImageData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    padding: const EdgeInsets.only(top: 3),
                    child: AspectRatio(
                        aspectRatio: 14.0 / 10.0,
                        child: Image.network(
                          snapshot.data.toString(),
                          height: 100,
                        )),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: FutureBuilder<DocumentSnapshot>(
                  future: motor.doc(documentId).get(),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
