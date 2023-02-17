import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/lecturer/components/features_card.dart';
import 'package:falcon/screens/lecturer/components/header.dart';
import 'package:falcon/screens/lecturer/components/topic_section.dart';

class LBody extends StatefulWidget {
  @override
  State<LBody> createState() => _LBodyState();
}

class _LBodyState extends State<LBody> {
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
          TopicSection(
            TopicName: 'Features',
          ),
          FeaCard(
            size: size,
            loggedInUser: loggedInUser,
          ),
        ],
      ),
    );
  }
}
