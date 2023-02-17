import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/firebase/FirebaseApi.dart';
import 'package:falcon/model/pay_Model.dart';
import 'package:falcon/model/user_model.dart';
import 'package:path/path.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({
    Key? key,
    required this.semId,
    required this.loggedInUser,
  }) : super(key: key);
  final UserModel loggedInUser;

  final semId;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  File? file;
  UploadTask? task;
  late String name = 'Not Submitted!';
  late CollectionReference reSub;
  PayModel Submission = PayModel();

  @override
  void initState() {
    super.initState();
    reSub = FirebaseFirestore.instance
        .collection('payment')
        .doc('${widget.loggedInUser.batch}')
        .collection('semesterPay')
        .doc(widget.semId)
        .collection('pay');

    reSub.doc(widget.loggedInUser.uid).get().then((val) {
      this.Submission = PayModel.fromMap(val.data());
      setState(() {
        name = '${Submission.pName}';
        print(name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //select button
    final selectButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            selectFile();
          },
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 30.0,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Select Payment Slip",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );

    //upload button
    final uploadButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            uploadFile().whenComplete(() => Navigator.of(context).pop());
          },
          child: Row(
            children: [
              Icon(
                Icons.cloud_upload,
                size: 30.0,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Upload Slip",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text('Upload Payment Slip'),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF3C4046),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color(0xFFFFFF),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            selectButton,
                            SizedBox(height: 20),
                            uploadButton,
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.upload_file),
        backgroundColor: Color(0xff0b3140),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
    final fileName = basename(file!.path);
    Fluttertoast.showToast(msg: fileName);
  }

  Future uploadFile() async {
    if (file == null) return;
    Fluttertoast.showToast(msg: 'File Uploading...');

    final String locate = 'Payment';
    final String subLocate = '${widget.loggedInUser.batch}';

    final fileName = basename(file!.path);
    final destination = '$locate/$subLocate/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    DocumentReference reSub = FirebaseFirestore.instance
        .collection('payment')
        .doc('${widget.loggedInUser.batch}')
        .collection('semesterPay')
        .doc(widget.semId)
        .collection('pay')
        .doc(widget.loggedInUser.uid);

    reSub.set({
      "pName": fileName,
      "pFile": urlDownload,
      'userId': widget.loggedInUser.uid,
    });
    Fluttertoast.showToast(msg: "Uploaded successfully!");
  }
}
