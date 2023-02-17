import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicSection extends StatelessWidget {
  const TopicSection({
    Key? key,
    // ignore: non_constant_identifier_names
    required this.TopicName,
    required this.texts,
  }) : super(key: key);

  // ignore: non_constant_identifier_names
  final String TopicName;
  final String texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                TopicName,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                texts,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
