import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EditMScreen extends StatefulWidget {
  const EditMScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<EditMScreen> createState() => _EditMScreenState();
}

class _EditMScreenState extends State<EditMScreen> {
  // editing Controller
  final mIndexEditingController = new TextEditingController();
  final mNameEditingController = new TextEditingController();
  final mOwnerEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(widget.title);

    //mindex field
    final mindexField = TextFormField(
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

    //mname field
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

    //mname field
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['mIndex'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 25,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            doc[index]['mName'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3C4046),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            doc[index]['mOwner'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          mIndexEditingController.text = doc[index]['mIndex'];

                          mNameEditingController.text = doc[index]['mName'];

                          mOwnerEditingController.text = doc[index]['mOwner'];

                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(0xFFFFFF),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(30.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            mindexField,
                                            SizedBox(height: 10),
                                            mNameField,
                                            SizedBox(height: 10),
                                            mOwnerField,
                                            SizedBox(height: 10),
                                            TextButton(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 15, 20, 15),
                                                child: Text(
                                                  'Update',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                snapshot
                                                    .data!.docs[index].reference
                                                    .update({
                                                  "mIndex":
                                                      mIndexEditingController
                                                          .text,
                                                  "mName":
                                                      mNameEditingController
                                                          .text,
                                                  "mOwner":
                                                      mNameEditingController
                                                          .text,
                                                }).whenComplete(() =>
                                                        Navigator.pop(context));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Module updated successfully!");
                                              },
                                              /*color: Color(0xff0b3140),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                            */
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
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
