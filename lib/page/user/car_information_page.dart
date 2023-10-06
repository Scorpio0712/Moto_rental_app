import 'package:carrental_app/page/user/rent_pay_page.dart';
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
  late dynamic motorSelectedKey = widget.motorSelected;
  DateTime? _startDate;
  DateTime? _endDate;

  late final _motor =
      FirebaseFirestore.instance.collection('motor').doc(motorSelectedKey);

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  int getSelectDateRange() {
    if (_startDate == _endDate && _startDate != null && _endDate != null) {
      return 1;
    } else if (_startDate != null && _endDate != null) {
      final durationDate = _endDate?.difference(_startDate!);
      return durationDate!.inDays + 1;
    } else {
      return 0;
    }
  }

  void navigatorToMotorDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentPayPage(
          motorDetail: motorSelectedKey,
          daysRent: getSelectDateRange(),
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
                      const Image(
                        image: AssetImage('assets/2.png'),
                        width: 350,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2100),
      );
}
