import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.size,
    required this.loggedInUser,
  }) : super(key: key);

  final Size size;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            height: size.height * 0.2 - 10,
            decoration: BoxDecoration(
              color: Color(0xff0b3140),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      '${loggedInUser.firstName} ${loggedInUser.lastName}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${loggedInUser.indexNo}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
