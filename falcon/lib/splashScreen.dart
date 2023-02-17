import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:falcon/login.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/admin.dart';
import 'package:falcon/screens/lecturer/lec_screen.dart';
import 'package:falcon/screens/students/student_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseuser) {
      if (firebaseuser == null) {
        Timer(
            Duration(seconds: 5),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen())));
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseuser.uid)
            .get()
            .then((uid) {
          this.loggedInUser = UserModel.fromMap(uid.data());

          if (loggedInUser.role == "admin") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminHome()));
          } else if (loggedInUser.role == "student") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StuHome()));
          } else if (loggedInUser.role == 'lecturer') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LecHome()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff0b3140),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/logo2.png",
                  height: 75.0,
                  width: 75.0,
                ),
                Text('Learning Management System',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
