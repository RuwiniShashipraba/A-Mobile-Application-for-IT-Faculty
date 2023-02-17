import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicSection extends StatelessWidget {
  const TopicSection({
    Key? key,
    // ignore: non_constant_identifier_names
    required this.TopicName,
  }) : super(key: key);

  // ignore: non_constant_identifier_names
  final String TopicName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Text(
            TopicName,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF3C4046),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
