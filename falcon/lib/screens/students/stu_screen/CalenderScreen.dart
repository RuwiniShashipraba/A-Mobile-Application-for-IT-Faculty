import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/model/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class Calender_Screen extends StatefulWidget {
  @override
  _Calender_ScreenState createState() => _Calender_ScreenState();
}

class _Calender_ScreenState extends State<Calender_Screen> {
  // string for displaying the error Message
  String? errorMessage;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime fDay = DateTime.now();
  late String date = '${fDay.year} - ${fDay.month} - ${fDay.day}';

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            child: TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                  date =
                      '${focusedDay.year} - ${focusedDay.month} - ${focusedDay.day}';

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CardViwer(
                                dbtitle: '${loggedInUser.batch}',
                                date: Utils.toDate(focusedDay),
                                day: '${focusedDay.day}',
                                month: '${focusedDay.month}',
                              )));
                });
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Color(0xff0b3140),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Color(0xff838f94),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardViwer extends StatefulWidget {
  CardViwer(
      {required this.dbtitle,
      required this.date,
      required this.day,
      required this.month});
  final dbtitle;
  final date;
  final day;
  final month;

  @override
  State<CardViwer> createState() => _CardViwerState();
}

class _CardViwerState extends State<CardViwer> {
  @override
  Widget build(BuildContext context) {
    CollectionReference evRef = FirebaseFirestore.instance
        .collection('calender')
        .doc(widget.dbtitle)
        .collection('event')
        .doc(widget.date)
        .collection('dayEvent');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.month == '1'
                  ? 'January'
                  : widget.month == '2'
                      ? 'February'
                      : widget.month == '3'
                          ? 'March'
                          : widget.month == '4'
                              ? 'April'
                              : widget.month == '5'
                                  ? 'May'
                                  : widget.month == '6'
                                      ? 'June'
                                      : widget.month == '7'
                                          ? 'July'
                                          : widget.month == '8'
                                              ? 'August'
                                              : widget.month == '9'
                                                  ? 'September'
                                                  : widget.month == '10'
                                                      ? 'October'
                                                      : widget.month == '11'
                                                          ? 'November'
                                                          : widget.month == '12'
                                                              ? 'December'
                                                              : '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.day,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: evRef.orderBy('from_time').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;

                  return Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc[index]['title'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff0b3140),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'From: ',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      doc[index]['from_date'] +
                                          '  ' +
                                          doc[index]['from_time'],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'To: ',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      doc[index]['to_date'] +
                                          '  ' +
                                          doc[index]['to_time'],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  child: Text(
                                    (doc[index]['link']) != null
                                        ? doc[index]['link']
                                        : '',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  onTap: () {
                                    lanuchWeb(doc[index]['link']);
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  doc[index]['description'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff0b3140),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else
            return Text("");
        },
      ),
    );
  }

  Future lanuchWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
