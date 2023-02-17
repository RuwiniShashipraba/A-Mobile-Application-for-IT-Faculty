import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/firebase/quiz_service.dart';
import 'package:falcon/model/utils.dart';
import 'package:falcon/widgets/quiz_play_widgets.dart';

class QuizPlay extends StatefulWidget {
  QuizPlay({
    required this.qId,
    required this.qName,
    required this.wId,
    required this.mId,
    required this.dtitle,
    required this.user,
    required this.index,
  });

  final qId;
  final qName;
  final wId;
  final mId;
  final dtitle;
  final user, index;

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int total = 0;

class _QuizPlayState extends State<QuizPlay> {
  late QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();
  QuestionModel questionModel = new QuestionModel();
  bool isLoading = true;
  late DateTime _fromDate;

  @override
  void initState() {
    databaseService
        .getQuestionData(widget.qId, widget.wId, widget.mId, widget.dtitle)
        .then((value) {
      questionSnaphot = value;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      _fromDate = DateTime.now();
      total = questionSnaphot.docs.length;
      setState(() {});
      print("init don $total ${widget.qId} ");
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
    questionModel.correctOption = '${questionModel.correctOption}';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map<String, String> questionDataMap = {
            "correctAnswers": _correct.toString(),
            "userId": widget.user,
            'userIndex': widget.index,
            'timestamp': Utils.toDateTime(_fromDate),
          };

          databaseService.addSubmissionData(widget.qId, widget.wId, widget.mId,
              widget.dtitle, widget.user, questionDataMap);
          Navigator.pop(context);

          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Container(
                      height: 240.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color(0xFFFFFF),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "$_correct / $total",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xff0b3140),
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    Text(
                                      "you answered $_correct answers correctly",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff0b3140),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "This is your final marks",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0xff0b3140),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.check),
        backgroundColor: Color(0xff0b3140),
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
  bool answerWasSelected = false;

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
              onTap: () {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  // if answer was already selected then nothing happens onTap
                  if (!answerWasSelected) {
                    setState(() {
                      optionSelected = '${widget.questionModel.option1}';
                      answerWasSelected = true;
                      _correct = _correct + 1;
                      _incorrect = _correct;
                    });
                  } else {
                    return;
                  }
                } else {
                  if (answerWasSelected) {
                    if (_incorrect == _correct) {
                      setState(() {
                        optionSelected = '${widget.questionModel.option1}';
                        _correct = _correct - 1;
                        answerWasSelected = false;
                      });
                    } else {
                      setState(() {
                        optionSelected = '${widget.questionModel.option1}';
                      });
                    }
                  } else {
                    setState(() {
                      optionSelected = '${widget.questionModel.option1}';
                    });
                  }
                }
              },
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
              onTap: () {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  // if answer was already selected then nothing happens onTap
                  if (!answerWasSelected) {
                    setState(() {
                      optionSelected = '${widget.questionModel.option2}';
                      answerWasSelected = true;
                      _correct = _correct + 1;
                      _incorrect = _correct;
                    });
                  } else {
                    return;
                  }
                } else {
                  if (answerWasSelected) {
                    if (_incorrect == _correct) {
                      setState(() {
                        optionSelected = '${widget.questionModel.option2}';
                        _correct = _correct - 1;
                        answerWasSelected = false;
                      });
                    } else {
                      setState(() {
                        optionSelected = '${widget.questionModel.option2}';
                      });
                    }
                  } else {
                    setState(() {
                      optionSelected = '${widget.questionModel.option2}';
                    });
                  }
                }
              },
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
              onTap: () {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  // if answer was already selected then nothing happens onTap
                  if (!answerWasSelected) {
                    setState(() {
                      optionSelected = '${widget.questionModel.option3}';
                      answerWasSelected = true;
                      _correct = _correct + 1;
                      _incorrect = _correct;
                    });
                  } else {
                    return;
                  }
                } else {
                  if (answerWasSelected) {
                    if (_incorrect == _correct) {
                      setState(() {
                        optionSelected = '${widget.questionModel.option3}';
                        _correct = _correct - 1;
                        answerWasSelected = false;
                      });
                    } else {
                      setState(() {
                        optionSelected = '${widget.questionModel.option3}';
                      });
                    }
                  } else {
                    setState(() {
                      optionSelected = '${widget.questionModel.option3}';
                    });
                  }
                }
              },
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
              onTap: () {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  // if answer was already selected then nothing happens onTap
                  if (!answerWasSelected) {
                    setState(() {
                      optionSelected = '${widget.questionModel.option4}';
                      answerWasSelected = true;
                      _correct = _correct + 1;
                      _incorrect = _correct;
                    });
                  } else {
                    return;
                  }
                } else {
                  if (answerWasSelected) {
                    if (_incorrect == _correct) {
                      setState(() {
                        optionSelected = '${widget.questionModel.option4}';
                        _correct = _correct - 1;
                        answerWasSelected = false;
                      });
                    } else {
                      setState(() {
                        optionSelected = '${widget.questionModel.option4}';
                      });
                    }
                  } else {
                    setState(() {
                      optionSelected = '${widget.questionModel.option4}';
                    });
                  }
                }
              },
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
