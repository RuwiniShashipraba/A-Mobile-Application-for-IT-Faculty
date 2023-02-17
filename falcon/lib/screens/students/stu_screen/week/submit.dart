import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/firebase/FirebaseApi.dart';
import 'package:falcon/model/sub_Model.dart';
import 'package:falcon/model/utils.dart';
import 'package:path/path.dart';

class StuSubScreen extends StatefulWidget {
  const StuSubScreen({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.dtitle,
    required this.aId,
    required this.user,
  }) : super(key: key);

  final wId;
  final wName;
  final mId, aId;
  final String dtitle;
  final String user;

  @override
  State<StuSubScreen> createState() => _StuSubScreenState();
}

class _StuSubScreenState extends State<StuSubScreen> {
  File? file;
  UploadTask? task;
  SubModel Submissions = SubModel();
  late String name = 'Not Submitted!';
  late CollectionReference reSub;
  late DateTime _fromDate;

  @override
  void initState() {
    super.initState();
    reSub = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment')
        .doc(widget.aId)
        .collection('Submissions');

    reSub.doc(widget.user).get().then((val) {
      this.Submissions = SubModel.fromMap(val.data());
      setState(() {
        name = '${Submissions.subName}';
        print(name);
      });
    });
    _fromDate = DateTime.now();
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
                "Select Document",
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
                "Upload Documnet",
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
            Text('Submission'),
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

    final String mId = widget.mId;
    final String locate = 'Assignment';

    final fileName = basename(file!.path);
    final destination = '$mId/$locate/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    DocumentReference reSub = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment')
        .doc(widget.aId)
        .collection('Submissions')
        .doc(widget.user);

    reSub.set({
      "subName": fileName,
      "subFile": urlDownload,
      'userId': widget.user,
      'timestamp': Utils.toDateTime(_fromDate),
    });
    Fluttertoast.showToast(msg: "Uploaded successfully!");
  }
}
