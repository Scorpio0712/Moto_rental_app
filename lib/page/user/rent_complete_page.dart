import 'package:carrental_app/page/user/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late final _motor =
      FirebaseFirestore.instance.collection('motor').doc(widget.motorDetail);
  late final user = FirebaseAuth.instance.currentUser!.email;

  String calculateTotalPrice() {
    final int totalPrice;
    totalPrice = widget.priceRent * widget.daysRent;
    return NumberFormat.simpleCurrency(locale: 'TH').format(totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3250),
        automaticallyImplyLeading: false,
        title: const Text(
          'Rent Completed',
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
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
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
                    style:
                        const TextStyle(color: Color(0xFFF9B17A), fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Icon(FontAwesomeIcons.arrowDownLong,
                      color: Colors.white, size: 30),
                  const SizedBox(height: 20),
                  const Image(
                    image: AssetImage('assets/2.png'),
                    width: 125,
                  ),
                  GestureDetector(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: _motor.get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
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
                  const SizedBox(height: 30),
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
            const SizedBox(height: 290),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.house,
                      ),
                    ),
                    const Text('Home'),
                  ],
                )
                // IconButton(
                //   onPressed: () {

                //   },
                //   icon: Icon(FontAwesomeIcons.house),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
