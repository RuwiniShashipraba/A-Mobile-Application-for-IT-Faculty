import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/model/utils.dart';

class LecChatRoom extends StatefulWidget {
  LecChatRoom(
      {required this.title, required this.loggedInUser, required this.dbtitle});

  final title, dbtitle;
  final UserModel loggedInUser;
  @override
  State<LecChatRoom> createState() => _LecChatRoomState();
}

class _LecChatRoomState extends State<LecChatRoom> {
  late CollectionReference nRef;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    DocumentReference addPro = FirebaseFirestore.instance
        .collection('chats')
        .doc('divder')
        .collection(widget.dbtitle)
        .doc(widget.loggedInUser.uid);

    addPro.set({
      "lecID": widget.loggedInUser.uid,
      "lecIndex": widget.loggedInUser.indexNo,
      'img': widget.loggedInUser.img,
      'lecName': widget.loggedInUser.firstName,
      'date': Utils.toDateTime(DateTime.now()),
    });

    nRef = _firestore
        .collection('chats')
        .doc('divder')
        .collection(widget.dbtitle)
        .doc(widget.loggedInUser.uid)
        .collection('msg');
    setState(() {});
  }

  final TextEditingController _message = TextEditingController();

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": widget.loggedInUser.firstName,
        'id': widget.loggedInUser.indexNo,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore
          .collection('chats')
          .doc('divder')
          .collection(widget.dbtitle)
          .doc(widget.loggedInUser.uid)
          .collection('msg')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.title),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: size.height / 1.245,
              width: size.width,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                reverse: true,
                child: ShowMessages(
                  Ref: nRef,
                  loggedInUser: widget.loggedInUser,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height / 17,
                    width: size.width / 1.29,
                    child: Scrollbar(
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          hintText: "Enter Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      onSendMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Color(0xff0b3140),
                      size: 25.0,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowMessages extends StatelessWidget {
  ShowMessages({required this.Ref, required this.loggedInUser});

  final CollectionReference Ref;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Ref.orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              Map<String, dynamic> chatMap =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return messageTile(chatMap, context, snapshot, index);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Builder messageTile(Map<String, dynamic> chatMap, BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return Builder(builder: (_) {
      final Size size = MediaQuery.of(context).size;
      return Container(
        width: size.width,
        alignment: chatMap['sendBy'] == loggedInUser.firstName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: InkWell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: chatMap['sendBy'] == loggedInUser.firstName
                    ? Color(0xff00bfa5)
                    : Color(0xff12526c),
              ),
              child: Column(
                children: [
                  Text(
                    chatMap['sendBy'] + '  ' + chatMap['id'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 250,
                  ),
                  Text(
                    chatMap['message'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          onTap: () {
            chatMap['sendBy'] == loggedInUser.firstName
                ? showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Container(
                            width: 100.0,
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
                                    "Delete Message",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF3C4046),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(120, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          child: Text(
                                            "Ok",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            snapshot.data!.docs[index].reference
                                                .delete();

                                            Navigator.pop(context);
                                          },
                                        ),
                                        SizedBox(width: 50),
                                        InkWell(
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ))
                : null;
          },
        ),
      );
    });
  }
}
