import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/students/stu_screen/week/submit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.title,
    required this.dtitle,
    required this.user,
  }) : super(key: key);

  final wId;
  final wName;
  final mId;
  final String title;
  final String dtitle;
  final String user;

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference rId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
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
                      trailing: IconButton(
                        icon: Icon(
                          Icons.upload_file,
                          size: 25.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StuSubScreen(
                                        wId: widget.wId,
                                        wName: widget.wName,
                                        mId: widget.mId,
                                        dtitle: widget.dtitle,
                                        aId: doc[index]['aId'],
                                        user: widget.user,
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
    );
  }
}

var dio = Dio();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory directory;
          Fluttertoast.showToast(msg: 'File Downloading...');

          try {
            if (Platform.isAndroid) {
              if (await _requestPermission(Permission.storage)) {
                directory = (await getExternalStorageDirectory())!;
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
            File saveFile = File(directory.path + "/$title");
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
        child: const Icon(Icons.download),
        backgroundColor: Color(0xff0b3140),
      ),
    );
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

        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      final snackBar = SnackBar(
        content: Text('Downloaded ${title}'),
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
