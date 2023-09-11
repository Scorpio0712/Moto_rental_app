import 'package:carrental_app/page/RentPayPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CarInformationPage extends StatefulWidget {
  final String motorSelected;
  const CarInformationPage({Key? key, required this.motorSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CarInformationPage();
}

class _CarInformationPage extends State<CarInformationPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final CollectionReference _motor =
      FirebaseFirestore.instance.collection('motor');
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  int? getSelectDateRange() {
    if (_startDate != null && _endDate != null) {
      final durationDate = _endDate?.difference(_startDate!);
      return durationDate?.inDays;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    _startDateController.text = "";
    _endDateController.text = "";
    super.initState();
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
                  height: 375,
                  width: MediaQuery.of(context).size.width,
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
                          future: _motor.doc(widget.motorSelected).get(),
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
                      const Image(
                        image: AssetImage('images/2.png'),
                        width: 350,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: _motor.doc(widget.motorSelected).get(),
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
                                    'Enging Capacity: \n${data['e.capacity']} CC',
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
                      height: 75,
                      width: 135,
                      child: TextField(
                        controller: _startDateController,
                        decoration: const InputDecoration(
                          icon: Icon(FontAwesomeIcons.calendar),
                          labelText: "Start Date: ",
                        ),
                        readOnly: true,
                        onTap: () async {
                          _startDate = await pickDate();
                          if (_startDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(_startDate!);
                            setState(() {
                              _startDateController.text = formattedDate;
                            });
                          } else {
                            print('Date is not Select');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 75,
                      width: 135,
                      child: TextField(
                        controller: _endDateController,
                        decoration: const InputDecoration(
                          icon: Icon(FontAwesomeIcons.calendar),
                          labelText: "End Date: ",
                        ),
                        readOnly: true,
                        onTap: () async {
                          _endDate = await pickDate();
                          if (_endDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(_endDate!);
                            setState(() {
                              _endDateController.text = formattedDate;
                            });
                          } else {
                            print('Date is not Select');
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rent Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFF9B17A)),
                      ),
                      Text(
                        '=',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFF9B17A)),
                      ),
                      Text(
                        '300 Baht / day \n250 Baht / week \n200 Baht / week',
                        style: TextStyle(color: Color(0xFFF9B17A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RentPayPage(),
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
                        child: const Text('Rent Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
