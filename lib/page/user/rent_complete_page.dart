import 'package:carrental_app/page/user/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class RentComPage extends StatefulWidget {
  static const String routeName = '/rent-complete';
  final String motorDetail;
  final int daysRent;
  final int priceRent;
  const RentComPage(
      {Key? key,
      required this.motorDetail,
      required this.daysRent,
      required this.priceRent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RentComPage();
}

class _RentComPage extends State<RentComPage> {
  var imageUrl;
  var imageName;
  final storage = FirebaseStorage.instance;
  late final _motor =
      FirebaseFirestore.instance.collection('motor').doc(widget.motorDetail);
  late final user = FirebaseAuth.instance.currentUser!.email;

  String calculateTotalPrice() {
    final int totalPrice;
    totalPrice = widget.priceRent * widget.daysRent;
    return NumberFormat.simpleCurrency(locale: 'TH').format(totalPrice);
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
        .collection('motor')
        .doc(widget.motorDetail)
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
        backgroundColor: const Color(0xFF2D3250),
        automaticallyImplyLeading: false,
        title: const Text(
          'In process',
          style: TextStyle(
            color: Color(0xFFF9B17A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3250),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        user!,
                        style: const TextStyle(
                            color: Color(0xFFF9B17A), fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      const Icon(FontAwesomeIcons.arrowDownLong,
                          color: Colors.white, size: 30),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Image.network(
                              snapshot.data.toString(),
                              width: 125,
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      GestureDetector(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: _motor.get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                data['brand'] + ' ' + data['model'],
                                style: const TextStyle(
                                  color: Color(0xFFF9B17A),
                                  fontSize: 18,
                                ),
                              );
                            }
                            return const Text('Loading...');
                          },
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Days',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Prices(Per Day)',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.daysRent}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${widget.priceRent}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0xFFF9B17A),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amounts',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Fee',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                calculateTotalPrice(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Text(
                                '0',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Please check status on "My order"',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await Navigator.pushReplacementNamed(
                              context, '/home-page');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.house,
                        ),
                      ),
                      const Text('Home'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
