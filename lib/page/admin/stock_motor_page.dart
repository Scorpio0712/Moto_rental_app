import 'package:carrental_app/service/get_stock_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockMotorPage extends StatefulWidget {
  static const String routeName = '/stock-motor';
  const StockMotorPage({Key? key}) : super(key: key);

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
              leading: IconButton(
                onPressed: () async {
                  await Navigator.popAndPushNamed(context, '/admin-home');
                },
                icon: const Icon(Icons.arrow_back),
              ),
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
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/add-motor');
                  },
                )
              ],
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: refreshCallback,
              child: Column(
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
                              return Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: motorDocsIds.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
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
                                                    const EdgeInsets.all(15),
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
            ),
          );
  }
}
