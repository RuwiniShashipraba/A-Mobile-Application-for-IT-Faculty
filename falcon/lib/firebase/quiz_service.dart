import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addQuizData(
      quizData, String qId, String wId, String mId, String dtitle) async {
    await FirebaseFirestore.instance
        .collection(dtitle)
        .doc(mId)
        .collection('Data')
        .doc(wId)
        .collection('ShowQuiz')
        .doc(qId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(
      quizData, String qId, String wId, String mId, String dtitle) async {
    await FirebaseFirestore.instance
        .collection(dtitle)
        .doc(mId)
        .collection('Data')
        .doc(wId)
        .collection('ShowQuiz')
        .doc(qId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuestionData(String qId, String wId, String mId, String dtitle) async {
    return await FirebaseFirestore.instance
        .collection(dtitle)
        .doc(mId)
        .collection('Data')
        .doc(wId)
        .collection('ShowQuiz')
        .doc(qId)
        .collection("QNA")
        .get();
  }

  Future<void> addSubmissionData(String qId, String wId, String mId,
      String dtitle, String uid, quizData) async {
    await FirebaseFirestore.instance
        .collection(dtitle)
        .doc(mId)
        .collection('Data')
        .doc(wId)
        .collection('ShowQuiz')
        .doc(qId)
        .collection("Submissions")
        .doc(uid)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }
}
