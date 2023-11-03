import 'package:carrental_app/page/admin/admin_home_page.dart';
import 'package:carrental_app/widget/slip_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class OrderInformationPage extends StatefulWidget {
  final String orderSelected;

  const OrderInformationPage({
    Key? key,
    required this.orderSelected,
  }) : super(key: key);

  @override
  State<OrderInformationPage> createState() => _OrderInformationPageState();
}

class _OrderInformationPageState extends State<OrderInformationPage> {
  bool processState = false;
  bool successState = false;
  bool problemState = false;
  var orderStatus;
  bool loading = false;
  late final orderSelected =
      FirebaseFirestore.instance.collection('orders').doc(widget.orderSelected);

  @override
  void initState() {
    super.initState();
    loadData();
    changeStatus();
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


  changeStatus() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderSelected)
        .get()
        .then((DocumentSnapshot ds) async {
      orderStatus = ds['orderStatus'];
    });

    debugPrint(orderStatus);
    
    if (orderStatus == 'process') {
      setState(() {
        processState = true;
      });
    } else if (orderStatus == 'success') {
      setState(() {
        successState = true;
      });
    } else {
      setState(() {
        problemState = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffb17a),
        title: const Text(
          'Order Information',
          style: TextStyle(
            color: Color(0xFF2D3250),
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
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xffffb17a),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage('assets/2.png'),
                          width: 200,
                        ),
                        GestureDetector(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: orderSelected.get(),
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
                        const SizedBox(height: 30),
                        GestureDetector(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: orderSelected.get(),
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
                                    future: orderSelected.get(),
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
                                    future: orderSelected.get(),
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Text(
                        'Slip Payment',
                        style:
                            TextStyle(color: Color(0xff252525), fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              builder: (context) => SlipAlert(
                                    orderSelected: widget.orderSelected,
                                  ),
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
                          'See Slip',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Status',
                        style:
                            TextStyle(color: Color(0xff252525), fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9B17A),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Process',
                                  style: TextStyle(
                                      color: Color(0xff252525), fontSize: 16),
                                ),
                                Checkbox(
                                  activeColor: const Color(0xFF2D3250),
                                  checkColor: Colors.white,
                                  value: processState,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      processState = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9B17A),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Success',
                                  style: TextStyle(
                                      color: Color(0xff252525), fontSize: 16),
                                ),
                                Checkbox(
                                  activeColor: const Color(0xFF2D3250),
                                  checkColor: Colors.white,
                                  value: successState,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      successState = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          OrderStatus.updateStatus(widget.orderSelected,
                              orderStatus, processState, successState);
                          showDialog(
                            builder: (context) => const AdminHomePage(),
                            context: context,
                          );
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
                          'Confirm',
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

class OrderStatus {
  static updateStatus(
      orderSelected, orderStatus, processState, successState) async {
    if (processState == true) {
      orderStatus = 'process';
    } else if (successState == true) {
      orderStatus = 'success';
    }

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderSelected)
        .update({"orderStatus": orderStatus});
  }
}
