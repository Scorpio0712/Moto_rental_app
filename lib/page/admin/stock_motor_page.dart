import 'package:carrental_app/page/admin/add_motor_page.dart';
import 'package:carrental_app/page/admin/admin_home_page.dart';

import 'package:carrental_app/service/get_stock_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockMotorPage extends StatefulWidget {
  const StockMotorPage({super.key});

  @override
  State<StockMotorPage> createState() => _StockMotorPageState();
}

class _StockMotorPageState extends State<StockMotorPage> {
  final List<String> motorDocsIds = [];
  bool loading = false;

  Future getStockDataList() async {
    await FirebaseFirestore.instance.collection('motor').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              motorDocsIds.add(document.reference.id);
            },
          ),
        );
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(),
            ),
          ),
          icon: const Icon(Icons.home),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffffb17a),
        title: const Text(
          'Stock',
          style: TextStyle(
            color: Color(0xFF2D3250),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMotorPage(),
                ),
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xffffb17a),
                        ),
                        height: MediaQuery.of(context).size.height * 0.85,
                        padding: const EdgeInsets.all(10),
                        child: FutureBuilder(
                          future: getStockDataList(),
                          builder: (context, snapshot) {
                            return loading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: motorDocsIds.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            padding: const EdgeInsets.all(5),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: GetStockData(
                                                      documentId:
                                                          motorDocsIds[index],
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
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
