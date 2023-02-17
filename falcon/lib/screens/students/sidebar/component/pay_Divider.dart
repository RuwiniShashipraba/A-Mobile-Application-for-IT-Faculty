import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/sidebar/component/paymnet_Slip.dart';

class LiSemScreen extends StatefulWidget {
  const LiSemScreen({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);
  final UserModel loggedInUser;

  @override
  State<LiSemScreen> createState() => _LiSemScreenState();
}

class _LiSemScreenState extends State<LiSemScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference SemRef = FirebaseFirestore.instance
        .collection('payment')
        .doc('${widget.loggedInUser.batch}')
        .collection('semesterPay');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Payment'),
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
                          Icons.add,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PayScreen(
                                        semId: doc[index]['semId'],
                                        loggedInUser: widget.loggedInUser,
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
