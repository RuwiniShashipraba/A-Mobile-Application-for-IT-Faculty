import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  OptionTile(
      {required this.description,
      required this.correctAnswer,
      required this.option,
      required this.optionSelected});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.optionSelected == widget.description
                        ? Color(0xff00bfa5)
                        : Colors.grey,
                    width: 1.5),
                color: widget.optionSelected == widget.description
                    ? Color(0xff00bfa5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24)),
            child: Text(
              widget.option,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 17,
                    color: widget.optionSelected == widget.description
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.description,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  color: Color(0xff0b3140),
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
