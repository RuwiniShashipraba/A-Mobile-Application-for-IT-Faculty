import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/quiz/marks.dart';
import 'package:falcon/screens/admin/inComponenet/Add_lecs/wekk_Details/quiz/quiz.dart';

class QuizTitle extends StatefulWidget {
  const QuizTitle({
    Key? key,
    required this.wId,
    required this.wName,
    required this.mId,
    required this.title,
    required this.dtitle,
  }) : super(key: key);

  final wId;
  final wName;
  final mId;
  final String title;
  final String dtitle;

  @override
  _QuizTitleState createState() => _QuizTitleState();
}

class _QuizTitleState extends State<QuizTitle> {
  // string for displaying the error Message
  String? errorMessage;

  // editing Controller
  final qNameEditingController = new TextEditingController();
  final deadEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String docqId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowQuiz')
        .doc()
        .id;

    DocumentReference reference = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowQuiz')
        .doc(docqId);

    CollectionReference refId = FirebaseFirestore.instance
        .collection(widget.dtitle)
        .doc(widget.mId)
        .collection('Data')
        .doc(widget.wId)
        .collection('ShowQuiz');

    //Module Name field
    final wNameField = TextFormField(
        autofocus: false,
        controller: qNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Quiz Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          qNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Quiz Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: qNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      qNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //Deadline field
    final deadField = TextFormField(
        autofocus: false,
        controller: deadEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Deadline cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          deadEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Deadline",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: deadEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      deadEditingController.clear();
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
            if (qNameEditingController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Quiz Name cannot be Empty");
            } else {
              reference.set({
                "qName": qNameEditingController.text,
                "qId": docqId,
                "time": FieldValue.serverTimestamp(),
                'deadline': deadEditingController.text,
              });
              qNameEditingController.clear();
              Fluttertoast.showToast(msg: "Quiz added successfully!");
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Create Quiz",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Quiz'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: refId.orderBy('time').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubmissionScreen(
                                    qId: doc[index]['qId'],
                                    dtitle: widget.dtitle,
                                    mId: widget.mId,
                                    wId: widget.wId,
                                  )));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          doc[index]['qName'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: Color(0xff0b3140),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(
                          'Click to view marks',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 25.0,
                          ),
                          color: Color(0xff00bfa5),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizMaker(
                                          qId: doc[index]['qId'],
                                          qName: doc[index]['qName'],
                                          dtitle: widget.dtitle,
                                          mId: widget.mId,
                                          wId: widget.wId,
                                        )));
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 25.0,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            snapshot.data!.docs[index].reference.delete();
                            Fluttertoast.showToast(
                                msg: "Deleted successfully!");
                          },
                        ),
                      ),
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
                            wNameField,
                            SizedBox(height: 15),
                            deadField,
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
