import 'package:carrental_app/auth/main_check.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckNameUserPage extends StatefulWidget {
  static const String routeName = '/add-user-details';

  const CheckNameUserPage({super.key});

  @override
  State<CheckNameUserPage> createState() => _CheckNameUserPageState();
}

class _CheckNameUserPageState extends State<CheckNameUserPage> {
  bool loading = false;
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

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
    return Scaffold(
      backgroundColor: const Color(0xFF2D3250),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Please input name and phone number',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xffffb17a),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        buildTextFieldName(),
                        const SizedBox(height: 10),
                        buildTextFieldPhoneNumber(),
                        const Spacer(),
                        buildButtonConfirm(),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Container buildTextFieldName() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: "Name-Lastname",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldPhoneNumber() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          hintText: "Phone Number",
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffffb17a)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildButtonConfirm() {
    return GestureDetector(
      onTap: confirmButton,
      child: Container(
        constraints: const BoxConstraints.expand(height: 50, width: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF2D3250),
        ),
        margin: const EdgeInsets.only(top: 14),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "Confirm",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Future confirmButton() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'name': _nameController.text.trim(),
      'phoneNumber': _phoneNumberController.text.trim(),
    });
    const MainPage();
  }
}
