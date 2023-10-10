import 'dart:io';
import 'package:carrental_app/service/order_data.dart';
import 'package:carrental_app/page/user/rent_complete_page.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class QRcodeAlert extends StatefulWidget {
  final String motorDetail;
  final int daysRent;
  final int priceRent;
  const QRcodeAlert({Key? key, required this.motorDetail, required this.daysRent, required this.priceRent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRcodeAlert();
}

class _QRcodeAlert extends State<QRcodeAlert> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  late final String fileName;

  Future selectFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('files/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('Error occurred!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('QR Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('data'),
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Container(
                            color: const Color(0xFF2D3250),
                            width: double.infinity,
                            child: const Image(
                              image: AssetImage('assets/thai_qr_payment.png'),
                              height: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Image(
                          image: AssetImage('assets/prompt_pay_logo.png'),
                          height: 25,
                        ),
                        const SizedBox(height: 5),
                        const Image(
                          image: AssetImage('assets/qr_code.png'),
                          height: 150,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Scan QR to Pay',
                          style: TextStyle(
                            color: Color(0xFFF9B17A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: selectFile,
                        child: const Text('Choose file'),
                      ),
                      if (_photo != null)
                        Expanded(
                          child: Text(fileName),
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (_photo == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      ' Must select photo',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(milliseconds: 1500),
                    // width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 75,
                      right: 20,
                      left: 20,
                    ),
                  ),
                );
              } else {
                OrderData.pushOrderData(widget.motorDetail, widget.daysRent, widget.priceRent);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentComPage(motorDetail: widget.motorDetail, daysRent: widget.daysRent, priceRent: widget.priceRent,),
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
