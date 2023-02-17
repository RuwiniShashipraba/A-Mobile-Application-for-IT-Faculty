import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({
    required this.mId,
    required this.date,
    required this.module,
  });

  final module;
  final mId;
  final date;

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    CollectionReference rrId = FirebaseFirestore.instance
        .collection(widget.module)
        .doc(widget.mId)
        .collection('Attendence')
        .doc(widget.date)
        .collection("Marks");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Attendence'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height / 17.5,
                    width: size.width,
                    child: Scrollbar(
                      child: Center(
                        child: Container(
                          child: StreamBuilder(
                            stream: rrId.snapshots(),
                            builder:
                                (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Text(
                                          "Total: " +
                                              '${snapshot.data!.docs.length}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 21,
                                                color: Color(0xff0b3140),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Text("");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: size.height / 1.245,
              width: size.width,
              child: StreamBuilder(
                stream: rrId.orderBy('timestamp').snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs;

                          return Card(
                            child: ListTile(
                              title: Text(
                                'Student ID: ' + doc[index]['userIndex'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff0b3140),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Text(
                                'Marked Time: ' + doc[index]['timestamp'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          );
                        });
                  } else
                    return Text("");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
