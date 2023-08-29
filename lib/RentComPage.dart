import 'package:carrental_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RentComPage extends StatefulWidget {
  const RentComPage({super.key});

  @override
  State<StatefulWidget> createState() => _RentComPage();
}

class _RentComPage extends State<RentComPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3250),
        automaticallyImplyLeading: false,
        title: const Text(
          'Rent Completed',
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
            Container(
              height: 350,
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
                    'Name Lastname',
                    style: TextStyle(color: Color(0xFFF9B17A), fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    FontAwesomeIcons.arrowDownLong,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: AssetImage('images/2.png'),
                    width: 125,
                  ),
                  Text(
                    'Yamaha Aerox',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF9B17A),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Days',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Prices(Bath/Day)',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '10',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '100',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Color(0xFFF9B17A),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amounts(Bath)',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Fee',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '3,000',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  icon: Icon(FontAwesomeIcons.house,),
                ),
                Text('Home'),
                ],)
                // IconButton(
                //   onPressed: () {
                  
                //   },
                //   icon: Icon(FontAwesomeIcons.house),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
