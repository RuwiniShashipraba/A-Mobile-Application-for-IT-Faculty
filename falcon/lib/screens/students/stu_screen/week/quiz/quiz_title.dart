import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/students/stu_screen/week/quiz/view_quiz.dart';

class QuizTitle extends StatefulWidget {
  const QuizTitle({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.title,
    required this.dtitle,
    required this.user,
    required this.index,
  }) : super(key: key);

  final wId;
  final wName;
  final mId;
  final String title;
  final String dtitle;
  final user, index;

  @override
  _QuizTitleState createState() => _QuizTitleState();
}

class _QuizTitleState extends State<QuizTitle> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final qNameEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference refId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowQuiz');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Quiz'),
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
                        doc[index]['qName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        'Deadline:  ' + doc[index]['deadline'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          size: 25.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPlay(
                                        qId: doc[index]['qId'],
                                        qName: doc[index]['qName'],
                                        dtitle: widget.dtitle,
                                        mId: widget.mId,
                                        wId: widget.wId,
                                        user: widget.user,
                                        index: widget.index,
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
