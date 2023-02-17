import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/lecturer/inComponenet/AlecMat/wekk_Details/mWeek.dart';

class LiMScreen extends StatefulWidget {
  const LiMScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<LiMScreen> createState() => _LiMScreenState();
}

class _LiMScreenState extends State<LiMScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection(widget.title);

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
                                  builder: (context) => WeekScreen(
                                        mId: doc[index]['mId'],
                                        mIndex: doc[index]['mIndex'],
                                        dtitle: widget.title,
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
