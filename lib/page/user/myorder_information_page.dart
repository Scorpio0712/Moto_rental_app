import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyOrderInformationPage extends StatefulWidget {
  static const String routeName = '/my-order-information';
  final String myOrderSelected;
  const MyOrderInformationPage({Key? key, required this.myOrderSelected})
      : super(key: key);

  @override
  State<MyOrderInformationPage> createState() => _MyOrderInformationPageState();
}

class _MyOrderInformationPageState extends State<MyOrderInformationPage> {
  var imageUrl;
  var imageName;
  final storage = FirebaseStorage.instance;
  late final myOrderSelected = FirebaseFirestore.instance
      .collection('orders')
      .doc(widget.myOrderSelected);
  bool processState = false;
  bool successState = false;
  bool problemState = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      loading = true;
    });

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

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
        .doc(widget.myOrderSelected)
        .get()
        .then((DocumentSnapshot ds) async {
      imageName = ds['picMotor'];
    });

    final path = 'motor/$imageName';
    final ref = storage.ref().child(path);
    final url = await ref.getDownloadURL();

    imageUrl = url;
    debugPrint(imageUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D3250),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'My Order',
          style: TextStyle(
            color: Color(0xffffb17a),
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xff2D3250),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Information',
                          style:
                              TextStyle(color: Color(0xffffb17a), fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            FutureBuilder(
                              future: getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Image.network(
                                        snapshot.data.toString(),
                                        width: 175,
                                      ),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            GestureDetector(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: myOrderSelected.get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Text(
                                      '${data['brandMotor']} ${data['modelMotor']} \n Color: ${data['colorMotor']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    );
                                  }
                                  return const Text('Loading...');
                                },
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: myOrderSelected.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return Text(
                                  'Name: ${data['nameUser']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                );
                              }
                              return const Text('Loading...');
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: myOrderSelected.get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> data =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Text(
                                          'Start: ${data['dateStartRent']} \n Total days: ${data['daysRent']}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        );
                                      }
                                      return const Text('Loading...');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: myOrderSelected.get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> data =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Text(
                                          'End: ${data['dateEndRent']} \nPrice/day: ${data['pricePerDay']}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        );
                                      }
                                      return const Text('Loading...');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Status',
                          style: TextStyle(
                              color: Color(0xFF2D3250),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: myOrderSelected.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                if (data['orderStatus'] == 'process') {
                                  return Text(
                                    '${data['orderStatus']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else if (data['orderStatus'] == 'success') {
                                  return Text(
                                    '${data['orderStatus']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return Text(
                                    '${data['orderStatus']} \nRemake: Please contact shops.(091-2345678)',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              }
                              return const Text('Loading...');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
