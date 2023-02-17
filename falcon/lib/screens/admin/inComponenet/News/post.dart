import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Add_Post extends StatefulWidget {
  const Add_Post({Key? key}) : super(key: key);

  @override
  _Add_PostState createState() => _Add_PostState();
}

class _Add_PostState extends State<Add_Post> {
  // our form key
  final _formKey = GlobalKey<FormState>();

  CollectionReference postRef = FirebaseFirestore.instance.collection('news');

  File? _image = null;
  final picker = ImagePicker();
  bool _isLoading = false;

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //nTitleField
    final nTitleField = TextFormField(
        autofocus: false,
        controller: titleEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Title Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          titleEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: titleEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      titleEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //nDesField
    final nDesField = TextFormField(
        autofocus: false,
        controller: descriptionEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Description Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          descriptionEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Description",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: descriptionEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      descriptionEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    // add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isLoading = true;
              });
              int date = DateTime.now().microsecondsSinceEpoch;
              firebase_storage.Reference ref =
                  firebase_storage.FirebaseStorage.instance.ref('news/$date');

              UploadTask uploadTask = ref.putFile(_image!.absolute);
              await Future.value(uploadTask);
              var newUrl = await ref.getDownloadURL();

              postRef.add({
                "nTitle": titleEditingController.text,
                "nDescription": descriptionEditingController.text,
                "nImage": newUrl,
                "nTime": date.toString(),
              }).then((value) {
                Fluttertoast.showToast(msg: 'News Published');
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: error.toString());
              });

              print(newUrl);
              setState(() {
                _isLoading = false;
              });

              Navigator.pop(context);
            }
          },
          child: Text(
            "Add News",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Add News'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      _image == null
                          ? Text('No Image Chosen')
                          : Image.file(_image!),
                      ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text('Choose Image from Gallery'),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50.0,
                            ),
                            nTitleField,
                            SizedBox(
                              height: 30.0,
                            ),
                            nDesField,
                            SizedBox(
                              height: 30.0,
                            ),
                            addButton,
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
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
}
