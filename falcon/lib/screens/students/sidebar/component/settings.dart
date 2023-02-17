import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/login.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/sidebar/component/user_page.dart';

class Setting extends StatefulWidget {
  Setting({required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xff0b3140),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3C4046),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Change Profile"),
            buildAccountOptionRow(context, "Change Password"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Color(0xff0b3140),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3C4046),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              hoverColor: Color(0xff0b3140),
              onPressed: () {
                if (title == 'Change Profile') {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ProfileView()));
                }

                if (title == 'Change Password') {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: const Color(0xFFFFFF),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Text(
                                      "Password Reset",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 22,
                                          color: Color(0xFF3C4046),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "If you've lost your password or wish to reset it, Click below button to get reset password email.",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextButton(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 15, 20, 15),
                                        child: Text(
                                          'Reset Your Password',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        resetPassword();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      },
                                      /*color: Color(0xff0b3140),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),*/
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  resetPassword() async {
    Fluttertoast.showToast(
        msg: "Password Reset Email Send to" + ' ${widget.loggedInUser.email}');
    String email = '${widget.loggedInUser.email}';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
