
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMotorData {
  static saveAddMotorData(
      {required String amount,
      required String brand,
      required String model,
      required String color,
      required String eCapacity,
      picMotor}) async {

        
    Map<String, dynamic> motorData = {
      "brand": brand,
      "model": model,
      "e.capacity": eCapacity,
      "color": color,
      "amount": amount,
      "picMotor": picMotor,
    };

    await FirebaseFirestore.instance.collection("motor").add(motorData);
  }
}
