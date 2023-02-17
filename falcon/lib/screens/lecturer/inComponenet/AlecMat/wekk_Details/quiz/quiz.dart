import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:falcon/firebase/quiz_service.dart';
import 'package:falcon/screens/lecturer/inComponenet/AlecMat/wekk_Details/quiz/quiz_play.dart';

class QuizMaker extends StatefulWidget {
  const QuizMaker({
    Key? key,
    required this.qId,
    required this.qName,
    required this.wId,
    required this.mId,
    required this.dtitle,
  }) : super(key: key);

  final qId;
  final qName;
  final wId;
  final mId;
  final dtitle;

  @override
  _QuizMakerState createState() => _QuizMakerState();
}

class _QuizMakerState extends State<QuizMaker> {
  @override
  Widget build(BuildContext context) {
    // string for displaying the error Message
    String? errorMessage;

    bool isLoading = false;

    DatabaseService databaseService = new DatabaseService();

    // our form key
    final _formKey = GlobalKey<FormState>();
    // editing Controller
    final questionEditingController = new TextEditingController();
    final OptionOneEditingController = new TextEditingController();
    final OptionTwoEditingController = new TextEditingController();
    final OptionThreeEditingController = new TextEditingController();
    final OptionFourEditingController = new TextEditingController();

    uploadQuizData() {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        Map<String, String> questionMap = {
          "question": questionEditingController.text,
          "option1": OptionOneEditingController.text,
          "option2": OptionTwoEditingController.text,
          "option3": OptionThreeEditingController.text,
          "option4": OptionFourEditingController.text,
        };

        databaseService
            .addQuestionData(
                questionMap, widget.qId, widget.wId, widget.mId, widget.dtitle)
            .then((value) {
          questionEditingController.clear();
          OptionOneEditingController.clear();
          OptionTwoEditingController.clear();
          OptionThreeEditingController.clear();
          OptionFourEditingController.clear();
          setState(() {
            isLoading = false;
          });

          Fluttertoast.showToast(msg: "Question added successfully!");
        }).catchError((e) {
          print(e);
        });
      } else {
        print("error is happening ");
      }
    }

    //question feild
    final QuestionField = TextFormField(
        autofocus: false,
        controller: questionEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Question cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          questionEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Question",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: questionEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      questionEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //option one feild
    final OptionOneField = TextFormField(
        autofocus: false,
        controller: OptionOneEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Option One cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          OptionOneEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Option 1 (Correct Answer)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: OptionOneEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      OptionOneEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //option two feild
    final OptionTwoField = TextFormField(
        autofocus: false,
        controller: OptionTwoEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Option Two cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          OptionTwoEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Option 2",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: OptionTwoEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      OptionTwoEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //option three feild
    final OptionThreeField = TextFormField(
        autofocus: false,
        controller: OptionThreeEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Option Three cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          OptionThreeEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Option 3",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: OptionThreeEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      OptionThreeEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //option four feild
    final OptionFourField = TextFormField(
        autofocus: false,
        controller: OptionFourEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Option Four cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          OptionFourEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Option 4",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: OptionFourEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      OptionFourEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          minWidth: 120.0,
          padding: EdgeInsets.fromLTRB(17, 15, 17, 15),
          onPressed: () {
            uploadQuizData();
          },
          child: Text(
            "Add",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //view button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          minWidth: 120.0,
          padding: EdgeInsets.fromLTRB(17, 15, 17, 15),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizPlay(
                          qId: widget.qId,
                          qName: widget.qName,
                          dtitle: widget.dtitle,
                          mId: widget.mId,
                          wId: widget.wId,
                        )));
          },
          child: Text(
            "View",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qName),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: isLoading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        QuestionField,
                        SizedBox(height: 30),
                        OptionOneField,
                        SizedBox(height: 20),
                        OptionTwoField,
                        SizedBox(height: 20),
                        OptionThreeField,
                        SizedBox(height: 20),
                        OptionFourField,
                        SizedBox(height: 35),
                        Row(
                          children: [
                            SizedBox(width: 28.0),
                            submitButton,
                            SizedBox(width: 25.0),
                            addButton,
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
