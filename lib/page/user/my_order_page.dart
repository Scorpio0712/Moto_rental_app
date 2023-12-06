import 'package:carrental_app/page/user/myorder_information_page.dart';
import 'package:carrental_app/service/get_myorder_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrderPage extends StatefulWidget {
  static const String routeName = '/my-order';
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final List<String> orderDocsIds = [];
  bool loading = false;

  final currentUser = FirebaseAuth.instance.currentUser;

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

  Future _getOrderData() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .where('emailUser', isEqualTo: currentUser!.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              orderDocsIds.add(document.reference.id);
            },
          ),
        );
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
              backgroundColor: const Color(0xFF2D3250),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () async {
                  await Navigator.pushReplacementNamed(context, '/home-page');
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
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF2D3250),
                        ),
                        height: MediaQuery.of(context).size.height * 0.85,
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
                                              MyOrderInformationPage(
                                            myOrderSelected:
                                                orderDocsIds[index],
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
                                              child: GetMyOrderData(
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
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
