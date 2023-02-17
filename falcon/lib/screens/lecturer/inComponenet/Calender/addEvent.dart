import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';
import 'package:falcon/model/utils.dart';

class AddEventPage extends StatefulWidget {
//  final EventModel note;

  const AddEventPage(
      {Key? key, required this.dbtitle, required this.loggedInUser})
      : super(key: key);
  final UserModel loggedInUser;
  final dbtitle;

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _link;

  late DateTime _fromDate;
  late DateTime _toDate;
  late TimeOfDay selectedTime;
  late TimeOfDay selectedTime2;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _link = TextEditingController();
    _fromDate = DateTime.now();
    _toDate = DateTime.now().add(Duration(hours: 2));
    selectedTime = TimeOfDay.now();
    selectedTime2 = TimeOfDay.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Title',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value!.isEmpty) ? "Please Enter title" : null,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'URL',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _link,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Description',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  maxLines: 5,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text(
                  "From",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  child: Text(
                    Utils.toDate(_fromDate),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => pickFromDateTime(pickDate: true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  child: Text(
                    Utils.toTime(_fromDate),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => pickFromDateTime(pickDate: false),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text(
                  "To",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C4046),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  child: Text(
                    Utils.toDate(_toDate),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => pickToDateTime(pickDate: true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  child: Text(
                    Utils.toTime(_toDate),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => pickToDateTime(pickDate: false),
                ),
              ),
              SizedBox(height: 15.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                processing = true;
                              });
                              CollectionReference eventRef = FirebaseFirestore
                                  .instance
                                  .collection('calender')
                                  .doc(widget.dbtitle)
                                  .collection('event')
                                  .doc(Utils.toDate(_fromDate))
                                  .collection('dayEvent');

                              await eventRef.add({
                                "title": _title.text,
                                "description": _description.text,
                                "from_date": Utils.toDate(_fromDate),
                                "from_time": Utils.toTime(_fromDate),
                                "to_date": Utils.toDate(_toDate),
                                "to_time": Utils.toTime(_toDate),
                                "link": _link.text,
                              });
                              Fluttertoast.showToast(
                                  msg: 'New Event Published');
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Add Event",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _link.dispose();
    super.dispose();
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_fromDate, pickDate: pickDate);
    if (date == null) return;
    setState(() {
      _fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_toDate, pickDate: pickDate);
    if (date == null) return;
    setState(() {
      _toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      //DateTime? firstDate,
      {required bool pickDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100),
      );

      if (initialDate == _fromDate) {
        if (date != null) {
          setState(() {
            _fromDate = date;
          });
        }
      }
      if (initialDate == _toDate) {
        if (date != null) {
          setState(() {
            _toDate = date;
          });
        }
      }

      if (date == null) {
        final time =
            Duration(hours: initialDate.hour, minutes: initialDate.minute);
        return date!.add(time);
      }
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }
}
