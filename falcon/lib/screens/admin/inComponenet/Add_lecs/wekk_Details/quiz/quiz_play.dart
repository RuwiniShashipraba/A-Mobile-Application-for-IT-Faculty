import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/firebase/quiz_service.dart';
import 'package:falcon/widgets/quiz_play_widgets.dart';

class QuizPlay extends StatefulWidget {
  QuizPlay({
    required this.qId,
    required this.qName,
    required this.wId,
    required this.mId,
    required this.dtitle,
  });

  final qId;
  final qName;
  final wId;
  final mId;
  final dtitle;

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

class _QuizPlayState extends State<QuizPlay> {
  late QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();
  QuestionModel questionModel = new QuestionModel();
  bool isLoading = true;

  @override
  void initState() {
    databaseService
        .getQuestionData(widget.qId, widget.wId, widget.mId, widget.dtitle)
        .then((value) {
      questionSnaphot = value;
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    this.questionModel = QuestionModel.fromMap(questionSnapshot.data());

    questionModel.question = '${questionModel.question}';

    /// shuffling the options
    List<String> options = [
      '${questionModel.option1}',
      '${questionModel.option2}',
      '${questionModel.option3}',
      '${questionModel.option4}',
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    print(questionModel.correctOption!.toLowerCase());

    return questionModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.qName),
        elevation: 1,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    questionSnaphot.docs.isEmpty
                        ? Container()
                        : ListView.builder(
                            itemCount: questionSnaphot.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnaphot.docs[index]),
                                index: index,
                              );
                            })
                  ],
                ),
              ),
            ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Q${widget.index + 1} ${widget.questionModel.question}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 18,
                      color: Color(0xff0b3140),
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {},
              child: OptionTile(
                option: "A",
                description: "${widget.questionModel.option1}",
                correctAnswer: '${widget.questionModel.correctOption}',
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {},
              child: OptionTile(
                option: "B",
                description: "${widget.questionModel.option2}",
                correctAnswer: '${widget.questionModel.correctOption}',
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {},
              child: OptionTile(
                option: "C",
                description: "${widget.questionModel.option3}",
                correctAnswer: '${widget.questionModel.correctOption}',
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {},
              child: OptionTile(
                option: "D",
                description: "${widget.questionModel.option4}",
                correctAnswer: '${widget.questionModel.correctOption}',
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionModel {
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctOption;

  QuestionModel({
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctOption,
  });

  // receiving data from server
  factory QuestionModel.fromMap(map) {
    return QuestionModel(
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      correctOption: map['option1'],
    );
  }
}
