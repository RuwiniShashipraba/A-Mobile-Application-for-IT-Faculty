import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class WeekNote extends StatefulWidget {
  const WeekNote({
    Key? key,
    required this.mId,
    required this.wId,
    required this.title,
    required this.dtitle,
    required this.wName,
  }) : super(key: key);

  final mId, wId, wName, title;
  final String dtitle;

  @override
  _WeekNoteState createState() => _WeekNoteState();
}

class _WeekNoteState extends State<WeekNote> {
  @override
  Widget build(BuildContext context) {
    CollectionReference refeId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowData');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: refeId.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                doc[index]['sdName'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff0b3140),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            children: [
                              Text(
                                doc[index]['sdFile'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF3C4046),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        if (('${doc[index]['sdLink']}').isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => View(
                                        url: doc[index]['sdLink'],
                                        title: doc[index]['sdName'],
                                        mId: widget.mId,
                                      )));
                        }
                      },
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

class View extends StatelessWidget {
  PdfViewerController? _pdfViewerController;
  final url;
  final String title;
  final mId;
  View({this.url, required this.title, required this.mId});

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
                newPath = newPath + "/falcon";
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
