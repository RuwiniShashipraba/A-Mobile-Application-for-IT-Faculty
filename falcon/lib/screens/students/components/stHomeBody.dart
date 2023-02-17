import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/components/header.dart';
import 'package:falcon/screens/students/components/module_card.dart';
import 'package:falcon/screens/students/components/topic_section.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(size: size, loggedInUser: loggedInUser),
          TopicSection(TopicName: "My Courses"),
          SizedBox(height: 10),
          ModuleCard(size: size, loggedInUser: loggedInUser),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
