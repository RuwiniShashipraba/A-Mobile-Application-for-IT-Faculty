import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/lecturer/inComponenet/Attendence/attendence.dart';

class LiMScreen extends StatefulWidget {
  const LiMScreen({
    Key? key,
    required this.dtitle,
    required this.module,
    required this.loggedInUser,
  }) : super(key: key);

  final String dtitle, module;
  final UserModel loggedInUser;

  @override
  State<LiMScreen> createState() => _LiMScreenState();
}

class _LiMScreenState extends State<LiMScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(widget.module);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.module),
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
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        doc[index]['mName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3C4046),
                          ),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendenceDivScreen(
                                        mId: doc[index]['mId'],
                                        mIndex: doc[index]['mIndex'],
                                        module: widget.module,
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
    );
  }
}
