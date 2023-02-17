import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/inComponenet/Add_modules/module.dart';
import 'package:falcon/screens/admin/inComponenet/Add_users/user.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/lecdivider.dart';
import 'package:falcon/screens/admin/inComponenet/Calender/CalenderDivider.dart';
import 'package:falcon/screens/admin/inComponenet/News/news.dart';
import 'package:falcon/screens/admin/inComponenet/Payment/payDivider.dart';

class FeaCard extends StatelessWidget {
  const FeaCard({
    required this.size,
    required this.loggedInUser,
  });

  final Size size;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(
              left: 10.0,
              right: 15.0,
            ),
            width: size.width * 1,
            height: 480,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (0.5 / .4),
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                MyFeat(
                  loggedInUser: loggedInUser,
                  title: 'User',
                  colour: Color(0xFF3C4046),
                  icon: Icons.supervised_user_circle,
                ),
                MyFeat(
                  loggedInUser: loggedInUser,
                  title: 'Module',
                  colour: Color(0xFF3C4046),
                  icon: Icons.local_library,
                ),
                MyFeat(
                    loggedInUser: loggedInUser,
                    title: 'Lec Material',
                    colour: Color(0xFF3C4046),
                    icon: Icons.picture_as_pdf),
                MyFeat(
                  loggedInUser: loggedInUser,
                  title: 'Calender',
                  colour: Color(0xFF3C4046),
                  icon: Icons.calendar_today,
                ),
                MyFeat(
                  loggedInUser: loggedInUser,
                  title: 'News',
                  colour: Color(0xFF3C4046),
                  icon: Icons.library_books,
                ),
                MyFeat(
                  loggedInUser: loggedInUser,
                  title: 'Payments',
                  colour: Color(0xFF3C4046),
                  icon: Icons.payment,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyFeat extends StatelessWidget {
  MyFeat(
      {required this.title,
      required this.icon,
      required this.colour,
      required this.loggedInUser});

  final String title;
  final IconData icon;
  final Color colour;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          if (title == "User") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminUserScreen(
                          title: title,
                          loggedInUser: loggedInUser,
                        )));
          } else if (title == "Module") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminModuleScreen(
                          title: title,
                          loggedInUser: loggedInUser,
                        )));
          } else if (title == "Lec Material") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModdScreen(
                          loggedInUser: loggedInUser,
                        )));
          } else if (title == "Calender") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CScreen(
                          loggedInUser: loggedInUser,
                        )));
          } else if (title == "News") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => News()));
          } else if (title == "Payments") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaScreen(
                          loggedInUser: loggedInUser,
                        )));
          }
        },
        splashColor: colour,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 50.0,
                color: Color(0xff0b3140),
              ),
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
      ),
    );
  }
}
