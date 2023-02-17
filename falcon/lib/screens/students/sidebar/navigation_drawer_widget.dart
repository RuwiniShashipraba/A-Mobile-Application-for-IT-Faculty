import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/login.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/sidebar/component/helpLine.dart';
import 'package:falcon/screens/students/sidebar/component/pay_Divider.dart';
import 'package:falcon/screens/students/sidebar/component/settings.dart';
import 'package:falcon/screens/students/sidebar/component/todolist.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

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
    final name = '${loggedInUser.firstName}' + ' ${loggedInUser.lastName}';
    final email = '${loggedInUser.email}';
    final urlImage = '${loggedInUser.img}';
    Size size = MediaQuery.of(context).size;

    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              size: size,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  buildMenuItem(
                    text: 'TodoList',
                    icon: Icons.list,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 12),
                  buildMenuItem(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Payment',
                    icon: Icons.payment,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Help Line',
                    icon: Icons.help,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 16),
                  //Divider(color: Colors.white70),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout_rounded,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'About Us',
                    icon: Icons.announcement_rounded,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(height: 45),
                  Center(
                      child: Text(
                    'Version: 1.0',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3C4046),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required Size size,
  }) =>
      Container(
          height: size.height * 0.275,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      (urlImage.isEmpty)
                          ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png' //Default Picture
                          : urlImage,
                    )),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xff0b3140),
          ));

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xff0b3140),
      ),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Color(0xFF3C4046),
          ),
        ),
      ),
      hoverColor: Color(0xff0b3140),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => todoScreen(loggedInUser: loggedInUser),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Setting(loggedInUser: loggedInUser),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LiSemScreen(loggedInUser: loggedInUser),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HelpScreen(),
        ));
        break;
      case 5:
        logout(context);
        break;
      case 6:
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(30.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Text(
                            "About Us",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF3C4046),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  "assets/images/login_logo.png",
                                  fit: BoxFit.contain,
                                )),
                          ),
                          Text(
                            "Sri Lanka Technological Campus (SLTC)",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: Color(0xff0b3140),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Stay in touch",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: Color(0xff0b3140),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  lanuchWeb('http://sltc.ac.lk');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.web,
                                      size: 22.0,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "http://sltc.ac.lk",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  lanuchWeb("tel:+94711100500");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      size: 22.0,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "+94 71 1100 500",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  lanuchEmail('info@sltc.ac.lk');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 22.0,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "info@sltc.ac.lk",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Text(
                              "©2021 Falcon's",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3C4046),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ));
        break;
    }
  }

  Future lanuchWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future lanuchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    // widget.logindata!.setBool('login', true);
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "User Logout!");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
