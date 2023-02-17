import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/model/user_model.dart';

class DelUScreen extends StatefulWidget {
  const DelUScreen({
    Key? key,
    required this.loggedInUser,
    required this.title,
  }) : super(key: key);
  final UserModel loggedInUser;
  final String title;

  @override
  State<DelUScreen> createState() => _DelUScreenState();
}

class _DelUScreenState extends State<DelUScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final indexNumberController = new TextEditingController();
  final roleController = new TextEditingController();
  final modulController = new TextEditingController();
  final batchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: firstNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      firstNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: secondNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      secondNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@sltc+.+ac+.lk").hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: emailEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      emailEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //modulField field
    final modulField = TextFormField(
        autofocus: false,
        controller: modulController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Module ID cannot be Empty");
          } else if ((value) != "7thModules") {
            if ((value) != "8thModules") {
              if ((value) != "null") {
                return ("Enter Valid Module ID");
              }
            }
          }
          return null;
        },
        onSaved: (value) {
          modulController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Module ID",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: modulController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      modulController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //roleField field
    final roleField = TextFormField(
        autofocus: false,
        controller: roleController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Role cannot be Empty");
          } else if ((value) != "admin") {
            if ((value) != "student") {
              if ((value) != "lecturer") {
                return ("Enter Valid Role");
              }
            }
          }

          return null;
        },
        onSaved: (value) {
          roleController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Role",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: roleController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      roleController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));
    //indexNumberField field
    final indexNumberField = TextFormField(
        autofocus: false,
        controller: indexNumberController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("IndexNumber cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          indexNumberController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "IndexNumber",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: indexNumberController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      indexNumberController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //batchField field
    final batchField = TextFormField(
        autofocus: false,
        controller: batchController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Batch Number cannot be Empty");
          } else if ((value) != "7") {
            if ((value) != "8") {
              if ((value) != "0") {
                return ("Enter Valid Module ID");
              }
            }
          }
          return null;
        },
        onSaved: (value) {
          batchController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Batch",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: batchController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      batchController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs;
                  return Card(
                    child: ListTile(
                      title: Text(
                        doc[index]['indexNo'],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0b3140),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            doc[index]['role'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF3C4046),
                              ),
                            ),
                          ),
                          Text(
                            doc[index]['email'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF3C4046),
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 30.0,
                        ),
                        color: Colors.redAccent,
                        onPressed: () {
                          firstNameEditingController.text =
                              doc[index]['firstName'];
                          secondNameEditingController.text =
                              doc[index]['lastName'];
                          modulController.text = doc[index]['module'];
                          batchController.text =
                              (doc[index]['batch']).toString();
                          indexNumberController.text = doc[index]['indexNo'];
                          roleController.text = doc[index]['role'];
                          emailEditingController.text = doc[index]['email'];

                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(0xFFFFFF),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(30.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            firstNameField,
                                            SizedBox(height: 10),
                                            secondNameField,
                                            SizedBox(height: 10),
                                            indexNumberField,
                                            SizedBox(height: 10),
                                            emailField,
                                            SizedBox(height: 10),
                                            modulField,
                                            SizedBox(height: 10),
                                            roleField,
                                            SizedBox(height: 10),
                                            batchField,
                                            SizedBox(height: 15),
                                            TextButton(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 15, 20, 15),
                                                child: Text(
                                                  'Delete',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                snapshot
                                                    .data!.docs[index].reference
                                                    .delete()
                                                    .whenComplete(() =>
                                                        Navigator.pop(context));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "User Delete successfully!");
                                              },
                                              /*color: Color(0xff0b3140),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              */
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
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
}
