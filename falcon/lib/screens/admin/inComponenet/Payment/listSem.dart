import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/inComponenet/Payment/listPayUsers.dart';

class LisScreen extends StatefulWidget {
  const LisScreen({
    Key? key,
    required this.title,
    required this.dbtitle,
    required this.loggedInUser,
  }) : super(key: key);

  final String title;
  final String dbtitle;
  final UserModel loggedInUser;

  @override
  State<LisScreen> createState() => _LisScreenState();
}

class _LisScreenState extends State<LisScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final SNameEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference SemRef = FirebaseFirestore.instance
        .collection('payment')
        .doc(widget.dbtitle)
        .collection('semesterPay');

    String docsId = FirebaseFirestore.instance
        .collection('payment')
        .doc(widget.dbtitle)
        .collection('semesterPay')
        .doc()
        .id;

    DocumentReference reference = FirebaseFirestore.instance
        .collection('payment')
        .doc(widget.dbtitle)
        .collection('semesterPay')
        .doc(docsId);

    //Module Name field
    final SNameField = TextFormField(
        autofocus: false,
        controller: SNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Semester Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          SNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Semester",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: SNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      SNameEditingController.clear();
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
            if (SNameEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Semester Name cannot be Empty");
            } else {
              reference.set({
                "semName": SNameEditingController.text,
                "semId": docsId,
              });
              SNameEditingController.clear();
              Fluttertoast.showToast(msg: "Semester added successfully!");
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Add Semester",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: SemRef.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['semName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LiUserScreen(
                                        semId: doc[index]['semId'],
                                        dbtitle: widget.dbtitle,
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
                            SNameField,
                            SizedBox(height: 15),
                            addButton,
                            SizedBox(height: 5),
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
}
