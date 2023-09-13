import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'rent_complete_page.dart';

class RentPayPage extends StatefulWidget {
  final String motorDetail;
  final int daysRent;
  const RentPayPage(
      {Key? key, required this.motorDetail, required this.daysRent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RentPayPage();
}

const List<String> list = <String>[
  'QR Payment',
  'Master Card',
  'Visa',
  'Mobile Banking'
];

class _RentPayPage extends State<RentPayPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2D3250),
        title: const Text(
          'Topic',
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
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3250),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Image(
                            image: AssetImage('images/2.png'),
                            width: 125,
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
                      const SizedBox(height: 50),
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
                Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    const Text(
                      'Payment:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                      width: 25,
                    ),
                    SizedBox(
                      width: 200,
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
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 325,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentComPage(),
                      ),
                    );
                  },
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
                  child: const Text('Pay now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
