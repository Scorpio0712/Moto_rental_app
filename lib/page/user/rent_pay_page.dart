import 'package:carrental_app/widget/qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RentPayPage extends StatefulWidget {
  static const String routeName = '/rent-pay';
  final String motorDetail;
  final int daysRent;
  final String dateStartRent;
  final String dateEndRent;

  const RentPayPage(
      {Key? key,
      required this.motorDetail,
      required this.daysRent,
      required this.dateStartRent,
      required this.dateEndRent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RentPayPage();
}

const List<String> list = <String>[
  'Qr Code',
];

class _RentPayPage extends State<RentPayPage> {
  var imageUrl;
  var imageName;
  final storage = FirebaseStorage.instance;
  late final dynamic _motorDetail = widget.motorDetail;
  late final int priceRent;
  late final _motor =
      FirebaseFirestore.instance.collection('motor').doc(_motorDetail);
  String dropdownValue = list.first;

  int managePrice() {
    if (widget.daysRent >= 30) {
      priceRent = 200;
    } else if (widget.daysRent >= 7 && widget.daysRent < 30) {
      priceRent = 250;
    } else {
      priceRent = 300;
    }
    return priceRent;
  }

  int calculateTotalPrice() {
    final int totalPrice;
    totalPrice = priceRent * widget.daysRent;
    return totalPrice;
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
        .doc(_motorDetail)
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
        backgroundColor: const Color(0xFF2D3250),
        title: const Text(
          'Payment',
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
          children: <Widget>[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3250),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
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
                                      width: 150,
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
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      return Text(
                                        data['brand'] + ' ' + data['model'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF9B17A),
                                          fontSize: 18,
                                        ),
                                      );
                                    }
                                    return const Text('Loading...');
                                  },
                                ),
                              ),
                            ],
                          ),
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
                                'Prices(Bath/Day)',
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
                                '${managePrice()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        height: 30,
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
                                'Amounts(Bath)',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${calculateTotalPrice()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text(
                            'Payment:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 25,
                          ),
                          SizedBox(
                            width: 180,
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(FontAwesomeIcons.arrowDown,
                                  color: Colors.black),
                              elevation: 16,
                              style: const TextStyle(
                                color: Color(0xFF2D3250),
                                fontSize: 20,
                              ),
                              isExpanded: true,
                              underline: Container(
                                  height: 2, color: const Color(0xFF2D3250)),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              builder: (context) => QRcodeAlert(
                                  motorDetail: _motorDetail,
                                  daysRent: widget.daysRent,
                                  priceRent: priceRent,
                                  dateStartRent: widget.dateStartRent,
                                  dateEndRent: widget.dateEndRent),
                              context: context,
                              barrierDismissible: false);
                        }, // show dialog
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9B17A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        child: const Text(
                          'Pay now',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
