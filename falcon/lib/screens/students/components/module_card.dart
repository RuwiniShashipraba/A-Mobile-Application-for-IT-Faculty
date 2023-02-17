import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/students/stu_screen/moduleScreen.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.size,
    required this.loggedInUser,
  });

  final Size size;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 5.0,
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 1000,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('${loggedInUser.module}')
                .snapshots(),
            builder: (context, modulesSnapshot) {
              if (modulesSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final modulsDocs = modulesSnapshot.data!.docs;
                return ListView.builder(
                  itemCount: modulsDocs.length,
                  controller: new ScrollController(keepScrollOffset: false),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MScreen(
                                        mIndex: modulsDocs[index]['mIndex'],
                                        mName: modulsDocs[index]['mName'],
                                        mId: modulsDocs[index]['mId'],
                                        loggedInUser: loggedInUser,
                                      )));
                        },
                        title: Text(
                          modulsDocs[index]['mIndex'],
                        ),
                        subtitle: Text(
                          modulsDocs[index]['mName'],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
