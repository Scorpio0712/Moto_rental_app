import 'dart:io';
import 'package:carrental_app/service/add_motor_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddMotorPage extends StatefulWidget {
  static const String routeName = '/add-motor';
  const AddMotorPage({Key? key}) : super(key: key);

  @override
  State<AddMotorPage> createState() => _AddMotorPageState();
}

class _AddMotorPageState extends State<AddMotorPage> {
  PlatformFile? selectImage;
  UploadTask? uploadTask;
  bool loading = false;
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _ecapacityController = TextEditingController();
  final _colorController = TextEditingController();
  final _amountController = TextEditingController();

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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      selectImage = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'motor/${selectImage!.name}';
    final file = File(selectImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    debugPrint('Download link: $urlDownload');
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
              backgroundColor: const Color(0xffffb17a),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () async {
                  await Navigator.popAndPushNamed(context, '/stock-motor');
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text(
                'Add motor',
                style: TextStyle(
                  color: Color(0xFF2D3250),
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xffffb17a),
                          ),
                          height: MediaQuery.of(context).size.height * 0.85,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              buildTextFieldBrand(),
                              buildTextFieldModel(),
                              buildTextFieldECapacity(),
                              buildTextFieldColor(),
                              buildTextFieldAmount(),
                              const SizedBox(height: 10),
                              buildTakeImageButton(),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 240,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: selectImage != null
                                    ? Image.file(
                                        File(selectImage!.path!),
                                        width: 240,
                                        height: 180,
                                      )
                                    : const Center(
                                        child: Text(
                                          'No photo',
                                          style: TextStyle(
                                              color: Color(0xffffb17a),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                              const Spacer(),
                              buildConfirmButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget buildTextFieldBrand() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _brandController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF2D3250)),
          ),
          labelText: 'Brand',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget buildTextFieldModel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _modelController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF2D3250)),
          ),
          labelText: 'Model',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget buildTextFieldECapacity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _ecapacityController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF2D3250)),
          ),
          labelText: 'Engine Capacity',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget buildTextFieldColor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _colorController,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF2D3250)),
          ),
          labelText: 'Color',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget buildTextFieldAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF2D3250)),
          ),
          labelText: 'Amount',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget buildTakeImageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D3250),
      ),
      onPressed: () {
        selectFile();
      },
      child: const Text(
        'Choose Photo',
        style: TextStyle(
          color: Color(0xffffb17a),
        ),
      ),
    );
  }

  Widget buildConfirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D3250),
      ),
      onPressed: () {
        if (selectImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'Please Choose Photo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1500),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ));
        } else {
          uploadFile();
          AddMotorData.saveAddMotorData(
              brand: _brandController.text.trim(),
              model: _modelController.text.trim(),
              eCapacity: _ecapacityController.text.trim(),
              color: _colorController.text.trim(),
              amount: _amountController.text.trim(),
              picMotor: selectImage!.name);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'Success',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 1500),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ));
          Navigator.pushNamed(context, '/stock-motor');
        }
      },
      child: const Text(
        'Confirm',
        style: TextStyle(
          color: Color(0xffffb17a),
        ),
      ),
    );
  }
}
