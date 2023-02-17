import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMScreen extends StatefulWidget {
  const AddMScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<AddMScreen> createState() => _AddMScreenState();
}

class _AddMScreenState extends State<AddMScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final mIndexEditingController = new TextEditingController();
  final mNameEditingController = new TextEditingController();
  final mOwnerEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String docId = FirebaseFirestore.instance.collection(widget.title).doc().id;

    DocumentReference reff =
        FirebaseFirestore.instance.collection(widget.title).doc(docId);

    //Module Index field
    final mIndexField = TextFormField(
        autofocus: false,
        controller: mIndexEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Module Index cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          mIndexEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Module Index",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: mIndexEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      mIndexEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //Module Name field
    final mNameField = TextFormField(
        autofocus: false,
        controller: mNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Module Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          mNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Module Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: mNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      mNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));
    
    //Module Owner field
    final mOwnerField = TextFormField(
        autofocus: false,
        controller: mOwnerEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Module Owner cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          mOwnerEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Module Owner",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: mOwnerEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      mOwnerEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              reff.set({
                "mIndex": mIndexEditingController.text,
                "mName": mNameEditingController.text,
                "mOwner": mOwnerEditingController.text,
                "mId": docId,
              });
              Fluttertoast.showToast(msg: "Module added successfully!");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AddMScreen(
                        title: widget.title,
                      )));
            }
          },
          child: Text(
            "Add Module",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  mIndexField,
                  SizedBox(height: 20),
                  mNameField,
                  SizedBox(height: 20),
                  mOwnerField,
                  SizedBox(height: 20),
                  addButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
