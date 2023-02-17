import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/stu_screen/week/assignments.dart';
import 'package:falcon/screens/students/stu_screen/week/quiz/quiz_title.dart';
import 'package:falcon/screens/students/stu_screen/week/weekNotes.dart';
import 'package:falcon/screens/students/stu_screen/week/week_Grades.dart';
import 'package:falcon/screens/students/stu_screen/week/week_Videos.dart';

class ModDividerScreen extends StatefulWidget {
  const ModDividerScreen({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.dtitle,
  }) : super(key: key);

  final wId;
  final wName;
  final mId;
  final String dtitle;

  @override
  _ModDividerScreenState createState() => _ModDividerScreenState();
}

class _ModDividerScreenState extends State<ModDividerScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.wName),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            // margin: EdgeInsets.only(
            //   left: 10.0,
            //   right: 15.0,
            // ),
            width: MediaQuery.of(context).size.width * 1,
            height: 480,
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: (1.8 / .4),
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                MyFeat(
                  title: 'Notes',
                  colour: Color(0xff00bfa5),
                  icon: Icons.notes,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                  user: '${loggedInUser.uid}',
                  index: '${loggedInUser.indexNo}',
                ),
                MyFeat(
                  title: 'Recorded Lessons',
                  colour: Color(0xff00bfa5),
                  icon: Icons.video_label,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                  user: '${loggedInUser.uid}',
                  index: '${loggedInUser.indexNo}',
                ),
                MyFeat(
                  title: 'Assignments',
                  colour: Color(0xff00bfa5),
                  icon: Icons.assignment,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                  user: '${loggedInUser.uid}',
                  index: '${loggedInUser.indexNo}',
                ),
                MyFeat(
                  title: 'Quiz',
                  colour: Color(0xff00bfa5),
                  icon: Icons.quiz,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                  user: '${loggedInUser.uid}',
                  index: '${loggedInUser.indexNo}',
                ),
                MyFeat(
                  title: 'Grades',
                  colour: Color(0xff00bfa5),
                  icon: Icons.score,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                  user: '${loggedInUser.uid}',
                  index: '${loggedInUser.indexNo}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyFeat extends StatelessWidget {
  MyFeat({
    required this.title,
    required this.icon,
    required this.colour,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.dtitle,
    required this.user,
    required this.index,
  });

  final String title;
  final IconData icon;
  final Color colour;
  final wId;
  final wName;
  final mId;
  final String dtitle;
  final String user;
  final String index;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Checker(context);
        },
        splashColor: colour,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 30.0,
                      color: Color(0xff0b3140),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF3C4046),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void Checker(context) {
    if (title == "Notes") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WeekNote(
                    wId: wId,
                    wName: wName,
                    mId: mId,
                    title: title,
                    dtitle: dtitle,
                  )));
    }
    if (title == "Recorded Lessons") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideosScreen(
                    wId: wId,
                    wName: wName,
                    mId: mId,
                    title: title,
                    dtitle: dtitle,
                  )));
    }
    if (title == "Assignments") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AssignmentScreen(
                    wId: wId,
                    wName: wName,
                    mId: mId,
                    title: title,
                    dtitle: dtitle,
                    user: user,
                  )));
    }
    if (title == "Quiz") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizTitle(
                    wId: wId,
                    wName: wName,
                    mId: mId,
                    title: title,
                    dtitle: dtitle,
                    user: user,
                    index: index,
                  )));
    }
    if (title == "Grades") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GradesScreen(
                    wId: wId,
                    wName: wName,
                    mId: mId,
                    title: title,
                    dtitle: dtitle,
                  )));
    }
  }
}
