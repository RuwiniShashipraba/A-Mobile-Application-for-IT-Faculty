import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/assignments.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/quiz/quiz_title.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/week_Grades.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/week_Notes.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/week_Videos.dart';

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
                ),
                MyFeat(
                  title: 'Recorded Lessons',
                  colour: Color(0xff00bfa5),
                  icon: Icons.video_label,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                ),
                MyFeat(
                  title: 'Assignments',
                  colour: Color(0xff00bfa5),
                  icon: Icons.assignment,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                ),
                MyFeat(
                  title: 'Quiz',
                  colour: Color(0xff00bfa5),
                  icon: Icons.quiz,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
                ),
                MyFeat(
                  title: 'Grades',
                  colour: Color(0xff00bfa5),
                  icon: Icons.score,
                  wId: widget.wId,
                  mId: widget.mId,
                  wName: widget.wName,
                  dtitle: widget.dtitle,
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
  });

  final String title;
  final IconData icon;
  final Color colour;
  final wId;
  final wName;
  final mId;
  final String dtitle;

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
              builder: (context) => NotesScreen(
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
