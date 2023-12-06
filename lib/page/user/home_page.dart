import 'package:carrental_app/widget/user_drawer.dart';
import 'package:carrental_app/page/user/car_information_page.dart';
import 'package:carrental_app/service/get_motor_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final user = FirebaseAuth.instance.currentUser;
  final List<String> _motor_DocsIds = [];

  Future _getMotorData() async {
    await FirebaseFirestore.instance.collection('motor').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              _motor_DocsIds.add(document.reference.id);
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

  void navigatorToMotorDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarInformationPage(
          motorSelected: _motor_DocsIds[index],
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/main-page', ModalRoute.withName('/'));
  }

  Future<void> refreshCallback() async {
    return await Future.delayed(const Duration(seconds: 2));
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
              backgroundColor: const Color(0xFF2D3250),
              automaticallyImplyLeading: false,
              title: const Text(
                'Motor Rental',
                style: TextStyle(
                  color: Color(0xffffb17a),
                ),
              ),
            ),
            endDrawer: UserDrawer(onSignOut: signOut),
            body: RefreshIndicator(
              onRefresh: refreshCallback,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: FutureBuilder(
                  future: _getMotorData(),
                  builder: (context, snapshot) {
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _motor_DocsIds.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => navigatorToMotorDetails(index),
                            child: GetMotorData(
                              documentId: _motor_DocsIds[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
