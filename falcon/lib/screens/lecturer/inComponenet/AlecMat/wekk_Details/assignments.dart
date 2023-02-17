import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:falcon/firebase/FirebaseApi.dart';
import 'package:falcon/screens/lecturer/inComponenet/AlecMat/wekk_Details/submissions.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.title,
    required this.dtitle,
  }) : super(key: key);

  final wId;
  final wName;
  final mId;
  final String title;
  final String dtitle;

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final sdNameEditingController = new TextEditingController();

  late DocumentReference AReference;
  late String docaId;

  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    docaId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment')
        .doc()
        .id;

    AReference = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment')
        .doc(docaId);

    CollectionReference rId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment');

    //sd Name field
    final sdNameField = TextFormField(
        autofocus: false,
        controller: sdNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Data cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          sdNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Deadline",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: sdNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      sdNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

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
                "Select File",
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
                "Upload File",
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
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.wName),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: rId.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc[index]['asName'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff0b3140),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPDF(
                                      url: doc[index]['asLink'],
                                      title: doc[index]['asName'],
                                      mId: widget.mId,
                                    )));
                      },
                      subtitle: Text(
                        'Deadline:  ' + doc[index]['deadline'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 25.0,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          snapshot.data!.docs[index].reference.delete();
                          Fluttertoast.showToast(msg: "Deleted successfully!");
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          size: 25.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubmissionScreen(
                                        aId: doc[index]['aId'],
                                        wId: widget.wId,
                                        mId: widget.mId,
                                        dtitle: widget.dtitle,
                                        asName: doc[index]['asName'],
                                      )));
                        },
                      ),
                    ),
                  );
                });
          } else
            return Text("");
        },
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
                            sdNameField,
                            SizedBox(height: 20),
                            uploadButton,
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.add),
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

    AReference.set({
      "asName": fileName,
      "deadline": sdNameEditingController.text,
      "asLink": urlDownload,
      'aId': docaId,
    });
    sdNameEditingController.clear();
    Fluttertoast.showToast(msg: "Uploaded successfully!");
  }
}

class ViewPDF extends StatelessWidget {
  PdfViewerController? _pdfViewerController;
  final url;
  final String title;
  final mId;
  ViewPDF({this.url, required this.title, required this.mId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
      ),
    );
  }
}
