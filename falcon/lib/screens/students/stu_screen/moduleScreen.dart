import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/stu_screen/attendence.dart';
import 'package:falcon/screens/students/stu_screen/week/weekdetails_divider.dart';

class MScreen extends StatefulWidget {
  final mIndex, mName, mId;
  const MScreen({
    Key? key,
    this.mIndex,
    this.mName,
    this.mId,
    required this.loggedInUser,
  }) : super(key: key);
  final UserModel loggedInUser;

  @override
  _MScreenState createState() => _MScreenState();
}

class _MScreenState extends State<MScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference refId = FirebaseFirestore.instance
        .collection('${widget.loggedInUser.module}')
        .doc(widget.mId)
        .collection('Data');

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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModDividerScreen(
                                      wId: doc[index]['wId'],
                                      mId: widget.mId,
                                      dtitle: '${widget.loggedInUser.module}',
                                      wName: doc[index]['wName'],
                                    )));
                      },
                    ),
                  );
                });
          } else
            return Text("");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendenceDivScreen(
                        mIndex: widget.mIndex,
                        mId: widget.mId,
                        loggedInUser: widget.loggedInUser,
                        module: '${widget.loggedInUser.module}',
                      )));
        },
        child: const Icon(
          Icons.supervised_user_circle,
          size: 30.0,
        ),
        backgroundColor: Color(0xff0b3140),
      ),
    );
  }
}
