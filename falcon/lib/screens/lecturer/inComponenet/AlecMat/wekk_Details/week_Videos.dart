import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:falcon/firebase/FirebaseApi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({
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
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final sdNameEditingController = new TextEditingController();

  UploadTask? task;
  File? file;

  var dio = Dio();
  var vtitle;
  var url;
  var fName;

  @override
  Widget build(BuildContext context) {
    CollectionReference rId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowVideo');

    //sd Name field
    final descripField = TextFormField(
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
            hintText: "Topic",
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
                "Select Video",
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
                "Upload Video",
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
                              doc[index]['vName'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff0b3140),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
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
                          Icons.download,
                          size: 25.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () async {
                          Directory directory;
                          Fluttertoast.showToast(msg: 'File Downloading...');

                          url = doc[index]['vLink'];
                          vtitle = doc[index]['vfileName'];

                          try {
                            if (Platform.isAndroid) {
                              if (await _requestPermission(
                                  Permission.storage)) {
                                directory =
                                    (await getExternalStorageDirectory())!;
                                String newPath = "";
                                print(directory);
                                List<String> paths = directory.path.split("/");
                                for (int x = 1; x < paths.length; x++) {
                                  String folder = paths[x];
                                  if (folder != "Android") {
                                    newPath += "/" + folder;
                                  } else {
                                    break;
                                  }
                                }
                                newPath = newPath + "/ITSchoolApp";
                                directory = Directory(newPath);
                              } else {
                                return null;
                              }
                            } else {
                              if (await _requestPermission(Permission.photos)) {
                                directory = await getTemporaryDirectory();
                              } else {
                                return null;
                              }
                            }
                            File saveFile = File(directory.path + "/$vtitle");
                            if (!await directory.exists()) {
                              await directory.create(recursive: true);
                            }
                            if (await directory.exists()) {
                              print('Saved Path:' + saveFile.path);
                              download2(dio, url, saveFile.path, context);
                            }
                          } catch (e) {
                            print(e);
                          }
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
                            descripField,
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
    Fluttertoast.showToast(msg: 'Video Uploading...');

    final String mId = widget.mId;

    final String locate = 'Videos';

    final fileName = basename(file!.path);
    final destination = '$mId/$locate/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowVideo')
        .doc()
        .set({
      "vName": sdNameEditingController.text,
      "vfileName": fileName,
      "vLink": urlDownload,
    });
    sdNameEditingController.clear();
    Fluttertoast.showToast(msg: "Uploaded successfully!");
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future download2(
      Dio dio, String url, String savePath, BuildContext context) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,

        // //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      final snackBar = SnackBar(
        content: Text('Downloaded ${vtitle}'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
