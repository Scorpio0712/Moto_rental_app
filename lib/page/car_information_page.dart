import 'package:carrental_app/page/RentPayPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CarInformationPage extends StatefulWidget {
  const CarInformationPage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _CarInformationPage();
}

class _CarInformationPage extends State<CarInformationPage> {
  
  TextEditingController dateController = TextEditingController();
  late final String documentId;

  @override
  void initState() {
    dateController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3250),
        title: const Text(
          'Topic',
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
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3250),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Yamaha Aerox',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF9B17A),
                          fontSize: 18,
                        ),
                      ),
                      Image(
                        image: AssetImage('images/2.png'),
                        width: 400,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 135,
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          icon: Icon(FontAwesomeIcons.calendar),
                          labelText: "By Date: ",
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await pickDate();
                          if (date != null) {
                            print(date);
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(date);
                            print(formattedDate);

                            setState(() {
                              dateController.text = formattedDate;
                            });
                          } else {
                            print('Date is not Select');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 135,
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          icon: Icon(FontAwesomeIcons.calendar),
                          labelText: "To Date: ",
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await pickDate();
                          if (date != null) {
                            print(date);
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(date);
                            print(formattedDate);

                            setState(() {
                              dateController.text = formattedDate;
                            });
                          } else {
                            print('Date is not Select');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 75,
                ),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        '300 Bath / Day',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
