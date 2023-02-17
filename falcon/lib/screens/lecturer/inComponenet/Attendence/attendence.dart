import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/utils.dart';
import 'package:falcon/screens/lecturer/inComponenet/Attendence/viewAttendece.dart';

class AttendenceDivScreen extends StatefulWidget {
  const AttendenceDivScreen({
    Key? key,
    required this.mId,
    required this.mIndex,
    required this.module,
  }) : super(key: key);
  final mId, mIndex, module;

  @override
  _AttendenceDivScreenState createState() => _AttendenceDivScreenState();
}

class _AttendenceDivScreenState extends State<AttendenceDivScreen> {
  late DateTime _fromDate;

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection(widget.module)
        .doc(widget.mId)
        .collection('Attendence')
        .doc(Utils.toDate(_fromDate));

    CollectionReference attef = FirebaseFirestore.instance
        .collection(widget.module)
        .doc(widget.mId)
        .collection('Attendence');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mIndex),
      ),
      body: StreamBuilder(
        stream: attef.orderBy('datetime').snapshots(),
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
                              builder: (context) => SubScreen(
                                    mId: widget.mId,
                                    date: doc[index]['date'],
                                    module: widget.module,
                                  )));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          doc[index]['date'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xff0b3140),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(
                          'Click to view Attendence',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        trailing: IconButton(
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
          print(Utils.toDate(_fromDate));

          reference.set({
            'date': Utils.toDate(_fromDate),
            'datetime': Utils.toDateTime(_fromDate),
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xff0b3140),
      ),
    );
  }
}
