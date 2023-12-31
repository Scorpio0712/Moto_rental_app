import 'package:carrental_app/page/user/rent_pay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarInformationPage extends StatefulWidget {
  static const String routeName = '/motor-information';
  final String motorSelected;
  const CarInformationPage({Key? key, required this.motorSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CarInformationPage();
}

class _CarInformationPage extends State<CarInformationPage> {
  var imageUrl;
  var imageName;
  final storage = FirebaseStorage.instance;
  late dynamic motorSelectedKey = widget.motorSelected;
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  late final _motor =
      FirebaseFirestore.instance.collection('motor').doc(motorSelectedKey);

  @override
  void initState() {
    super.initState();
  }

  int getSelectDateRange() {
    if (DateFormat('dd/MM/yyy').format(selectedDates.start) ==
        DateFormat('dd/MM/yyy').format(selectedDates.end)) {
      return 1;
    } else if (DateFormat('dd/MM/yyy').format(selectedDates.start) != null &&
        DateFormat('dd/MM/yyy').format(selectedDates.end) != null) {
      final duration = selectedDates.duration.inDays + 1;
      return duration;
    } else {
      return 0;
    }
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
        .doc(widget.motorSelected)
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

  void navigatorToMotorDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentPayPage(
          motorDetail: motorSelectedKey,
          daysRent: getSelectDateRange(),
          dateStartRent: DateFormat('dd/MM/yyy').format(selectedDates.start),
          dateEndRent: DateFormat('dd/MM/yyy').format(selectedDates.end),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2D3250),
        title: const Text(
          'Information',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3250),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
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
                      FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.35,
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  snapshot.data.toString(),
                                  width: 200,
                                ),
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: _motor.get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'Engine Capacity: \n${data['e.capacity']} CC',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    'Color: \n${data['color']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              );
                            }
                            return const Text('Loading...');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 135,
                      child: ElevatedButton(
                        onPressed: () async {
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(3000),
                          );
                          if (dateTimeRange != null) {
                            setState(() {
                              selectedDates = dateTimeRange;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3250),
                        ),
                        child: const Text(
                          'Choose Date',
                          style: TextStyle(color: Color(0xFFF9B17A)),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Start date: ${DateFormat('dd/MM/yyy').format(selectedDates.start)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'End date: ${DateFormat('dd/MM/yyy').format(selectedDates.end)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Number of Days Selected: ${getSelectDateRange()} days',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3250),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 25.0),
                  padding: const EdgeInsets.all(15),
                  child: const Column(
                    children: [
                      Text(
                        'Rent Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFF9B17A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '1 days \n1 week \n1 month',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFFF9B17A)),
                          ),
                          Text(
                            '=',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFFF9B17A)),
                          ),
                          Text(
                            '300 Baht / day \n250 Baht / day \n200 Baht / day',
                            style: TextStyle(color: Color(0xFFF9B17A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: InkWell(
                    child: Container(
                      constraints:
                          const BoxConstraints.expand(height: 45, width: 125),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF9B17A)),
                      // margin: EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Rent now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF2D3250),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () => navigatorToMotorDetails(),
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
