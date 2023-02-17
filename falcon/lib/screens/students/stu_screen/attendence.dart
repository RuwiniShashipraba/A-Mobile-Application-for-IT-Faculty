import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/model/utils.dart';

class AttendenceDivScreen extends StatefulWidget {
  const AttendenceDivScreen({
    Key? key,
    required this.loggedInUser,
    required this.mId,
    required this.mIndex,
    required this.module,
  }) : super(key: key);
  final UserModel loggedInUser;
  final mId, mIndex, module;

  @override
  _AttendenceDivScreenState createState() => _AttendenceDivScreenState();
}

class _AttendenceDivScreenState extends State<AttendenceDivScreen> {
  late DateTime _fromDate;

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection(widget.module)
        .doc(widget.mId)
        .collection('Attendence')
        .doc(Utils.toDate(_fromDate));

    CollectionReference attef = FirebaseFirestore.instance
        .collection(widget.module)
        .doc(widget.mId)
        .collection('Attendence');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mIndex),
      ),
      body: StreamBuilder(
        stream: attef.orderBy('datetime').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['date'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        'Mark Attendence',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          attef
                              .doc(doc[index]['date'])
                              .collection('Marks')
                              .doc(widget.loggedInUser.uid)
                              .set({
                            'userIndex': widget.loggedInUser.indexNo,
                            'userId': widget.loggedInUser.uid,
                            'timestamp': Utils.toDateTime(_fromDate),
                          });
                          Fluttertoast.showToast(msg: 'Marked!');
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
