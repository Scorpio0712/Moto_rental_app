import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PersonDetailsDialog extends StatefulWidget {
  const PersonDetailsDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonDetailsDialogState();
}

class _PersonDetailsDialogState extends State<PersonDetailsDialog> {
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
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('Error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                        child: const Text('Choose file')),
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
        TextButton(
          child: Text('Regret'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
