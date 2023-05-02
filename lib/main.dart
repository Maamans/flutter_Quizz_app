import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';
import 'package:flare_flutter/flare_actor.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

String animation = 'idle';

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  Icon iconCorrect = Icon(Icons.check, color: Colors.green);
  Icon iconWrong = Icon(Icons.close, color: Colors.red);

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (userPickedAnswer == correctAnswer) {
        scoreKeeper.add(iconCorrect);
        animation = 'success';
      } else {
        scoreKeeper.add(iconWrong);
        animation = 'fail';
      }
      quizBrain.nextQuestion();
    });

    if (quizBrain.isFinished()) {
      int result = scoreKeeper.where((e) => e == iconCorrect).length;
     
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('end of quiz'),
          content:  Text('you got $result out of 13 questions '),
          //desc: 'Your result is $result points',
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      quizBrain.reset();
      scoreKeeper = [];
      animation = 'idle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 200,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: AssetImage('assets/images/quiz.jpeg'),
                ),
                Text(
                  'Question ${(quizBrain.getQuestionNumber() + 1).toString()}/${(quizBrain.getQuestionBankLength() - 1).toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10.0),
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      quizBrain.getQuestionText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'True',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                    ),
                  ),
                  onPressed: () {
                    //The user picked true.
                    checkAnswer(true);
                  },
                ),
                TextButton(
                  child: Text(
                    'False',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    //The user picked false.
                    checkAnswer(false);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: scoreKeeper,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Alert(
    {required BuildContext context,
    required type,
    required String title,
    required String desc,
    required List<TextButton> buttons}) {}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/