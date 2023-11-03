import 'dart:io';
import 'package:carrental_app/service/order_data.dart';
import 'package:carrental_app/page/user/rent_complete_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class QRcodeAlert extends StatefulWidget {
  final String motorDetail;
  final int daysRent;
  final int priceRent;
  final String dateStartRent;
  final String dateEndRent;

  const QRcodeAlert(
      {Key? key,
      required this.motorDetail,
      required this.daysRent,
      required this.priceRent,
      required this.dateStartRent,
      required this.dateEndRent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRcodeAlert();
}

class _QRcodeAlert extends State<QRcodeAlert> {
  PlatformFile? pickFiles;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickFiles = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'slips/${pickFiles!.name}';
    final file = File(pickFiles!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: $urlDownload');
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
            const Text('data'),
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
                      if (pickFiles != null)
                        Expanded(
                          child: Text(pickFiles!.name),
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
              if (pickFiles == null) {
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
                uploadFile();
                OrderData.pushOrderData(
                    widget.motorDetail,
                    widget.daysRent,
                    widget.priceRent,
                    widget.dateEndRent,
                    widget.dateStartRent,
                    pickFiles!.name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentComPage(
                      motorDetail: widget.motorDetail,
                      daysRent: widget.daysRent,
                      priceRent: widget.priceRent,
                    ),
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
