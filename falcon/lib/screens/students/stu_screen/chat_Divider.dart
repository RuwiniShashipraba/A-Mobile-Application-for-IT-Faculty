import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/chat/chat.dart';
import 'package:falcon/model/user_model.dart';

class ChScreen extends StatefulWidget {
  @override
  _ChScreenState createState() => _ChScreenState();
}

class _ChScreenState extends State<ChScreen> {
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
                  title: 'Public',
                  colour: Color(0xff00bfa5),
                  icon: Icons.circle,
                  loggedInUser: loggedInUser,
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
    required this.loggedInUser,
  });

  final String title;
  final UserModel loggedInUser;
  final IconData icon;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          if (title == "Public") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoom(
                          title: title,
                          loggedInUser: loggedInUser,
                        )));
          }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
