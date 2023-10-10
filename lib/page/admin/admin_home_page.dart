import 'package:carrental_app/page/user/rent_pay_page.dart';
import 'package:carrental_app/service/get_order_data.dart';
import 'package:carrental_app/widget/admin_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<String> _order_DocsIds = [];


  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future _getOrderData() async {
    await FirebaseFirestore.instance.collection('orders').orderBy('order', descending: false).get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              _order_DocsIds.add(document.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffffb17a),
        automaticallyImplyLeading: false,
        title: const Text(
          'Motor Rental',
          style: TextStyle(
            color: Color(0xFF2D3250),
          ),
        ),
      ),
      endDrawer: AdminDrawer(
        onSignOut: signOut,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Order',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xffffb17a),
                ),
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: _getOrderData(),
                  builder: (context, snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _order_DocsIds.length,
                        
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.2,
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                color: Colors.white60,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            GetOrderData(
                                              documentId: _order_DocsIds[index],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
