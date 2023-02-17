import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/model/utils.dart';

class todoScreen extends StatefulWidget {
  @override
  todoScreen({required this.loggedInUser});

  final UserModel loggedInUser;

  _todoScreenState createState() => _todoScreenState();
}

class _todoScreenState extends State<todoScreen> {
  // editing Controller
  final MsgEditingController = new TextEditingController();
  late DateTime _fromDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    CollectionReference refhId = FirebaseFirestore.instance
        .collection('todoList')
        .doc(widget.loggedInUser.uid)
        .collection('list');

    final msgField = TextFormField(
        autofocus: false,
        controller: MsgEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Message cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          MsgEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Message",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: MsgEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      MsgEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (MsgEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: "TextField cannot be Empty");
            } else {
              refhId.add({
                "textMsg": MsgEditingController.text,
                "Date": (DateTime.now().day).toString(),
                "datTime": Utils.toDateTime(_fromDate),
              });
              MsgEditingController.clear();
              Fluttertoast.showToast(msg: "Added successfully!");
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Add",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Todolist'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: refhId.orderBy('datTime').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Color(0xff00bfa5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            doc[index]['Date'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              doc[index]['textMsg'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff0b3140),
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 20.0,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            snapshot.data!.docs[index].reference.delete();
                            Fluttertoast.showToast(
                                msg: "Deleted successfully!");
                          },
                        ),
                      ],
                    ),
                  );
                });
          } else
            return Text("");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(
                              'Add TodoList',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff0b3140),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 25),
                            msgField,
                            SizedBox(height: 15),
                            addButton,
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xff0b3140),
      ),
    );
  }
}
