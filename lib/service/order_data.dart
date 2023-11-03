import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderData {
  static pushOrderData(motorDetail, int daysRent, int priceRent, dateStartRent,
      dateEndRent, fileName) async {
    var motorBrand;
    var motorModel;
    var motorColor;
    var nameUser;
    var emailUser;
    final userAuth = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('motor')
        .doc(motorDetail)
        .get()
        .then((DocumentSnapshot ds) async {
      motorBrand = ds['brand'];
      motorModel = ds['model'];
      motorColor = ds['color'];
    });
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
      "orderStatus" : 'process',
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
    };

    await FirebaseFirestore.instance.collection("orders").add(orderData);
  }
}
