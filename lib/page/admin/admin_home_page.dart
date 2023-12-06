import 'package:carrental_app/page/admin/order_information_page.dart';
import 'package:carrental_app/service/get_order_data.dart';
import 'package:carrental_app/widget/admin_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  static const String routeName = '/admin-home';
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<String> orderDocsIds = [];
  bool loading = false;

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/main-page', ModalRoute.withName('/'));
  }

  Future _getOrderData() async {
    await FirebaseFirestore.instance.collection('orders').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              orderDocsIds.add(document.reference.id);
            },
          ),
        );
  }

  Future<void> refreshCallback() async {
    return await Future.delayed(const Duration(seconds: 2));
  }

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
            body: RefreshIndicator(
              onRefresh: refreshCallback,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          'Order',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xffffb17a),
                        ),
                        height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.all(10),
                        child: FutureBuilder(
                          future: _getOrderData(),
                          builder: (context, snapshot) {
                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: orderDocsIds.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderInformationPage(
                                            orderSelected: orderDocsIds[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      padding: const EdgeInsets.all(5.0),
                                      child: Card(
                                        color: Colors.white60,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              child: GetOrderData(
                                                documentId: orderDocsIds[index],
                                              ),
                                            ),
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
            ),
          );
  }
}
