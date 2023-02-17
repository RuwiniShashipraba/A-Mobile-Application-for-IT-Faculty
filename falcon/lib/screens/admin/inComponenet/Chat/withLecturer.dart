import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/screens/admin/inComponenet/Chat/chatWithLecturer.dart';

class lecChatScreen extends StatefulWidget {
  const lecChatScreen({
    Key? key,
    required this.title,
    required this.loggedInUser,
    required this.dbtitle,
  }) : super(key: key);

  final String title, dbtitle;
  final UserModel loggedInUser;

  @override
  State<lecChatScreen> createState() => _lecChatScreenState();
}

class _lecChatScreenState extends State<lecChatScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('chats')
        .doc('divder')
        .collection(widget.dbtitle);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: ref.orderBy('date').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0.5, 8, 0.5),
                        child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              (doc[index]['img'].isEmpty)
                                  ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png' //Default Picture
                                  : doc[index]['img'],
                            )),
                      ),
                      title: Text(
                        doc[index]['lecIndex'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: (Text(
                        doc[index]['lecName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3C4046),
                          ),
                        ),
                      )),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.message_rounded,
                          size: 25.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LecChatRoom(
                                        title: doc[index]['lecName'],
                                        dbtitle: widget.dbtitle,
                                        lecID: doc[index]['lecID'],
                                        loggedInUser: widget.loggedInUser,
                                      )));
                        },
                      ),
                    ),
                  );
                });
          } else
            return Text("");
        },
      ),
    );
  }
}
