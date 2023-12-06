
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderData {
  static pushOrderData(motorDetail, int daysRent, int priceRent, dateStartRent,
      dateEndRent, fileName) async {
    var motorBrand;
    var motorModel;
    var motorColor;
    var nameUser;
    var emailUser;
    var motorAmount;
    var motorPic;

    await FirebaseFirestore.instance
        .collection('motor')
        .doc(motorDetail)
        .get()
        .then((DocumentSnapshot ds) async {
      motorBrand = ds['brand'];
      motorModel = ds['model'];
      motorColor = ds['color'];
      motorAmount = ds['amount'];
      motorPic = ds['picMotor'];

    });

    final userAuth = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth?.uid)
        .get()
        .then((DocumentSnapshot ds) async {
      nameUser = ds['name'];
      emailUser = ds['email'];
    });

    final int totalPrice = priceRent * daysRent;

    Map<String, dynamic> orderData = {
      "orderStatus": 'process',
      "nameUser": nameUser,
      "emailUser": emailUser,
      "brandMotor": motorBrand,
      "modelMotor": motorModel,
      "colorMotor": motorColor,
      "daysRent": daysRent,
      "pricePerDay": priceRent,
      "priceTotals": totalPrice,
      "dateStartRent": dateStartRent,
      "dateEndRent": dateEndRent,
      "slipPayment": fileName,
      "picMotor": motorPic,
    };

    await FirebaseFirestore.instance.collection("orders").add(orderData);

    motorAmount = motorAmount - 1;
    FirebaseFirestore.instance
        .collection('motor')
        .doc(motorDetail)
        .update({'amount': motorAmount});

    if (motorAmount < 1) {
      await FirebaseFirestore.instance
          .collection('motor')
          .doc(motorDetail)
          .delete();
      debugPrint('Delete $motorDetail completed');
    }
  }
}
