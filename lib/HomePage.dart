import 'package:carrental_app/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'CarInforPage.dart';

class HomePage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D3250),
        title: Text(
          'Hello, ${widget.user?.email}',
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarInforPage(),
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
                                AspectRatio(
                                  aspectRatio: 15.0 / 11.0,
                                  child: Image.asset(
                                    'images/2.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Yamaha Aerox',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      // padding: const EdgeInsets.fromLTRB(5, 0, 5, 5)
                      // child: CardContainer(
                      //   name: number[index].toString(),
                      // ),
                    }),
              ),
            ],
          ),
        ),
      ),
    );
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
            onTap: () {
            },
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
                FirebaseAuth.instance.signOut();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }),
        ],
      ),
    );
  }
}
