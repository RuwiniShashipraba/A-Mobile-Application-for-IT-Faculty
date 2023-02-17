import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/inComponenet/Add_modules/add.dart';
import 'package:falcon/screens/admin/inComponenet/Add_modules/delete.dart';
import 'package:falcon/screens/admin/inComponenet/Add_modules/edit.dart';

class ModScreen extends StatefulWidget {
  const ModScreen({
    Key? key,
    required this.loggedInUser,
    required this.ttle,
  }) : super(key: key);
  final UserModel loggedInUser;
  final String ttle;

  @override
  _ModScreenState createState() => _ModScreenState();
}

class _ModScreenState extends State<ModScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
              left: 10.0,
              right: 15.0,
            ),
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
                  title: '7thModules',
                  colour: Color(0xff00bfa5),
                  icon: Icons.circle,
                  purpose: '${widget.ttle}',
                ),
                MyFeat(
                  title: '8thModules',
                  colour: Color(0xff00bfa5),
                  icon: Icons.circle,
                  purpose: '${widget.ttle}',
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
    required this.purpose,
  });

  final String title;
  final IconData icon;
  final Color colour;
  final String purpose;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          if (title == "7thModules") {
            Checker(context);
          }
          if (title == "8thModules") {
            Checker(context);
          }
        },
        splashColor: colour,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    icon,
                    size: 30.0,
                    color: Color(0xff0b3140),
                  ),
                  SizedBox(width: 5.0),
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
            ],
          ),
        ),
      ),
    );
  }

  void Checker(context) {
    if (purpose == "Add Module") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddMScreen(
                    title: title,
                  )));
    } else if (purpose == "Edit Module") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditMScreen(
                    title: title,
                  )));
    } else if (purpose == "Delete Module") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DelMScreen(
                    title: title,
                  )));
    }
  }
}
