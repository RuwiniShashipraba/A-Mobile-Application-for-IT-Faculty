import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    CollectionReference refhId = FirebaseFirestore.instance.collection('helpL');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Help Line'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: refhId.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['hName'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        doc[index]['hEmail'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xff0b3140),
                          ),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.email,
                          size: 30.0,
                        ),
                        color: Color(0xff00bfa5),
                        onPressed: () {
                          lanuchEmail('${doc[index]['hEmail']}');
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

  Future lanuchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
