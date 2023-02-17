import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/weekdetails_divider.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({
    Key? key,
    required this.mId,
    required this.mIndex,
    required this.dtitle,
  }) : super(key: key);
  final String mId;
  final String mIndex;
  final String dtitle;

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final wNameEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String docwId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc()
        .id;

    DocumentReference reference = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(docwId);

    CollectionReference refId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data');

    //Module Name field
    final wNameField = TextFormField(
        autofocus: false,
        controller: wNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Week Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          wNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Week Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: wNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      wNameEditingController.clear();
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
            if (wNameEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Week Name cannot be Empty");
            } else {
              reference.set({
                "wName": wNameEditingController.text,
                "wId": docwId,
                "time": FieldValue.serverTimestamp(),
              });
              wNameEditingController.clear();
              Fluttertoast.showToast(msg: "Week added successfully!");
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Add Week",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.mIndex),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: refId.orderBy('time').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['wName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModDividerScreen(
                                        wId: doc[index]['wId'],
                                        wName: doc[index]['wName'],
                                        mId: widget.mId,
                                        dtitle: widget.dtitle,
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
                            wNameField,
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
