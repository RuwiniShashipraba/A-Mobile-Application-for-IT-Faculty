import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    CollectionReference nRef = FirebaseFirestore.instance.collection('news');

    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: StreamBuilder(
        stream: nRef.orderBy('nTime').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(19.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              image: doc[index]['nImage'],
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: MediaQuery.of(context).size.width * 0.9,
                              placeholder:
                                  'assets/images/White Youtube Thumbnail.jpg',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc[index]['nTitle'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff0b3140),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              doc[index]['nDescription'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF3C4046),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
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
