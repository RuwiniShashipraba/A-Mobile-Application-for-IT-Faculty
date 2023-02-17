import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:falcon/login.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/admin.dart';
import 'package:falcon/screens/lecturer/lec_screen.dart';
import 'package:falcon/screens/students/student_screen.dart';

class Path extends StatefulWidget {
  @override
  State<Path> createState() => _PathState();
}

class _PathState extends State<Path> {
  //current user
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseuser) {
      if (firebaseuser == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseuser.uid)
            .get()
            .then((uid) {
          this.loggedInUser = UserModel.fromMap(uid.data());

          if (loggedInUser.role == "admin") {
            Fluttertoast.showToast(msg: "Login Successful!");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminHome()));
          } else if (loggedInUser.role == "student") {
            Fluttertoast.showToast(msg: "Login Successful!");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StuHome()));
          } else if (loggedInUser.role == 'lecturer') {
            Fluttertoast.showToast(msg: "Login Successful!");
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
