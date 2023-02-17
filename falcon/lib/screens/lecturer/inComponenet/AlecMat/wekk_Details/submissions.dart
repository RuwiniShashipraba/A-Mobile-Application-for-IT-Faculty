import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({
    required this.wId,
    required this.aId,
    required this.mId,
    required this.dtitle,
    required this.asName,
  });

  final wId;
  final aId;
  final mId;
  final String dtitle;
  final String asName;

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  var dio = Dio();
  var vtitle;
  var url;
  var fName;

  @override
  Widget build(BuildContext context) {
    CollectionReference rrId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowAssignment')
        .doc(widget.aId)
        .collection('Submissions');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Submissions'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: rrId.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;

                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['subName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        'Submitted Time: ' + doc[index]['timestamp'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
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

                          url = doc[index]['subFile'];
                          vtitle = doc[index]['subName'];

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
                                newPath = newPath +
                                    "/ITSchoolApp" +
                                    '/Submissions' +
                                    '/${widget.asName}';
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
