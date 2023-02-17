import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:falcon/firebase/FirebaseApi.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/sidebar/component/manage_profile_information_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  File? _image;
  UploadTask? task;
  final picker = ImagePicker();

  CollectionReference proRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36.0),
                bottomRight: Radius.circular(36.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.white,
                          child: (_image != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            FileImage(_image!), //Selected Image
                                        fit: BoxFit.fill),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            (('${loggedInUser.img}').isEmpty)
                                                ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png' //Default Picture
                                                : '${loggedInUser.img}',
                                          ),
                                          fit: BoxFit.fill)),
                                ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 25.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              pickImage();
                            },
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 25.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              delFile();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  'Upload Image',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ManageProfileInformationWidget(
              currentUser: loggedInUser,
            ),
          ),
          ButtonTheme(
            minWidth: 10.0,
            height: 25.0,
            child: TextButton(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Text(
                  'Save Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              onPressed: () {
                uploadFile().whenComplete(() => Navigator.pop(context));
              },
              /*color: Color(0xff0b3140),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),*/
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Future pickImage() async {
    var file = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (file != null) {
        _image = File(file.path);
      } else {
        print("not selected");
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) return;
    Fluttertoast.showToast(msg: 'Image Uploading...');

    int date = DateTime.now().microsecondsSinceEpoch;

    final destination = 'profiles/$date';

    task = FirebaseApi.uploadFile(destination, _image!);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final newPUrl = await snapshot.ref.getDownloadURL();

    proRef.doc(loggedInUser.uid).update({
      "img": newPUrl,
    });

    Fluttertoast.showToast(msg: "Uploaded successfully!");
  }

  Future delFile() async {
    proRef.doc(loggedInUser.uid).update({
      "img": '',
    }).whenComplete(() => Navigator.pop(context));
    Fluttertoast.showToast(msg: "Image removed successfully!");
  }
}
