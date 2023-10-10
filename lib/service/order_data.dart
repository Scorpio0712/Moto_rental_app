import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderData {
  
  static pushOrderData(motorDetail, int daysRent, int priceRent) async {
    var motorBrand;
    var motorModel;
    var motorColor;
    final userAuth = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('motor')
        .doc(motorDetail).get().then((DocumentSnapshot ds) async {
          motorBrand = ds['brand'];
          motorModel = ds['model'];
          motorColor = ds['color'];
        });
    
    final int totalPrice = priceRent * daysRent;
    
  

    Map<String, dynamic> orderData = {
      "name": userAuth?.displayName,
      "email": userAuth?.email,
      "brandMotor": motorBrand,
      "modelMotor": motorModel,
      "colorMotor": motorColor,
      "daysRent": daysRent,
      "pricePerDay": priceRent,
      "priceTotals": totalPrice,
    };

    await FirebaseFirestore.instance.collection("orders").add(orderData);
  }
}
