import 'package:carrental_app/auth/main_page.dart';
import 'package:carrental_app/read%20data/get_motor_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'car_information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> docIDs = [];

  Future getData() async {
    await FirebaseFirestore.instance.collection('motor').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D3250),
        title: Text(
          'Welcome, ${user?.email}',
          style: const TextStyle(color: Color(0xffffb17a)),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => buildButtonMenu(context),
                  ),
                );
              },
              child: const Icon(
                FontAwesomeIcons.bars,
                size: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return Expanded(
                  child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarInformationPage(),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const AspectRatio(
                              aspectRatio: 15.0 / 11.0,
                              // child: Image.asset(
                              //   '',
                              //   width: 100,
                              //   height: 100,
                              // ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: GetMotorData(documentId: docIDs[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ),
      ),
    );
  }
}

Widget buildButtonMenu(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF676F9D)),
          child: Text(
            'Setting',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.house,
            size: 25,
            color: Color(0xffffb17a),
          ),
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 24),
          ),
          visualDensity: const VisualDensity(vertical: 0),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(height: 15),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.gear,
            size: 25,
            color: Color(0xffffb17a),
          ),
          title: const Text(
            'Setting',
            style: TextStyle(fontSize: 24),
          ),
          visualDensity: const VisualDensity(vertical: 0),
          onTap: () {},
        ),
        const Divider(height: 15),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.rightFromBracket,
            size: 25,
            color: Color(0xffffb17a),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontSize: 24),
          ),
          onTap: () {
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            );
          },
        ),
      ],
    ),
  );
}


// return Container(
//                   height: MediaQuery.of(context).size.width * 0.6,
//                   padding: const EdgeInsets.all(5.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CarInforPage(),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       color: Colors.white60,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 10,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const AspectRatio(
//                             aspectRatio: 15.0 / 11.0,
//                             // child: Image.asset(
//                             //   '',
//                             //   width: 100,
//                             //   height: 100,
//                             // ),
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text(
//                               docIDs[index],
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );