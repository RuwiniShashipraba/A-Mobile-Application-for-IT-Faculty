import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({
    required this.wId,
    required this.mId,
    required this.dtitle,
    required this.qId,
  });

  final wId, qId;
  final mId;
  final String dtitle;

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference rrId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowQuiz')
        .doc(widget.qId)
        .collection("Submissions");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Quiz Marks'),
          ],
        ),
      ),
      body: StreamBuilder(
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marks: ' + doc[index]['correctAnswers'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff0b3140),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Submitted Time: ' + doc[index]['timestamp'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
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
