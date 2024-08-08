import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../score_manager.dart';
import 'common_layout.dart';
import '../data/quiz_data.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<int> answeredQuestions = [];
  List<int> selectedQuestions = [];
  int currentQuestionIndex = 0;
  bool showAnimation = false;
  bool isCorrect = false;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool showResult = false;
  bool isAnswering = false;

  @override
  void initState() {
    super.initState();
    _selectRandomQuestions();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstVisit = prefs.getBool('isFirstQuizVisit') ?? true;

    if (isFirstVisit) {
      _showIntroDialog();
      await prefs.setBool('isFirstQuizVisit', false);
    }
  }

  void _showIntroDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('퀴즈 페이지 안내'),
          content: const Text('물 절약을 위해 문제를 풀고 포인트를 받아가세요!'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectRandomQuestions() {
    Random random = Random();
    while (selectedQuestions.length < 5) {
      int questionIndex = random.nextInt(quizzes.length);
      if (!selectedQuestions.contains(questionIndex)) {
        selectedQuestions.add(questionIndex);
      }
    }
    setState(() {
      currentQuestionIndex = 0;
    });
  }

  void _checkAnswer(String answer) {
    if (isAnswering) return;

    setState(() {
      isAnswering = true;
      bool isAnswerCorrect =
          quizzes[selectedQuestions[currentQuestionIndex]][2] == answer;
      showAnimation = true;
      isCorrect = isAnswerCorrect;
      if (isAnswerCorrect) {
        correctAnswers++;
        Provider.of<ScoreManager>(context, listen: false).addPoints(10);
      } else {
        wrongAnswers++;
      }
      answeredQuestions.add(selectedQuestions[currentQuestionIndex]);
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        showAnimation = false;
        isAnswering = false;
        if (answeredQuestions.length < 5) {
          currentQuestionIndex++;
        } else {
          _showResultDialog();
        }
      });
    });
  }

  void _showResultDialog() {
    setState(() {
      showResult = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("퀴즈 결과", textAlign: TextAlign.center),
        content: Text("맞은 문제: $correctAnswers\n틀린 문제: $wrongAnswers",
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                showResult = false;
              });
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: showAnimation || showResult,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (quizzes.isNotEmpty &&
                      currentQuestionIndex < quizzes.length)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      padding: EdgeInsets.all(16.0),
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '문제 ${currentQuestionIndex + 1} / 5',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 50),
                          Text(
                            quizzes[selectedQuestions[currentQuestionIndex]][1],
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                          if (quizzes.isNotEmpty &&
                      currentQuestionIndex < quizzes.length)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _checkAnswer("O"),
                          child: Text("O"),
                        ),
                        ElevatedButton(
                          onPressed: () => _checkAnswer("X"),
                          child: Text("X"),
                        ),
                      ],
                    ),
                        ],
                      ),
                    ),
                  
                ],
              ),
            ),
            if (showAnimation)
              Center(
                child: Lottie.asset(
                  isCorrect
                      ? 'assets/animation_correct.json'
                      : 'assets/animation_wrong.json',
                  width: isCorrect ? 200 : 100,
                  height: isCorrect ? 200 : 100,
                  animate: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}