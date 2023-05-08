import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'feud_question_view.dart';
import 'question_screen.dart';
import 'feud_question.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'net_get_ip.dart';
import 'awaiting_connection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<String> q = [Question1_question];
    return ChangeNotifierProvider(
        create: (_) => SocketService(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: HomeView()));
    //home: ButtonWidget(),
    //home: ChangeNotifierProvider(
    //  create: (_) => SocketService(),
    //  child: HomeView(),
    //)));
  }
}

class FamilyFeudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Feud Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FamilyFeudQuiz(),
    );
  }
}

class FamilyFeudGame extends StatefulWidget {
  @override
  _FamilyFeudGameState createState() => _FamilyFeudGameState();
}

class _FamilyFeudGameState extends State<FamilyFeudGame> {
  int _currentQuestionIndex = 0;
  int _playerOneScore = 0;
  int _playerTwoScore = 0;
  bool _playerOneTurn = true;

  final List<String> _questions = [
    "    Yes, I finished my homework.",
    "No, I missed the new episode of my favorite TV show.",
    "Yes, I remembered to feed the dog this morning.",
    "Yes, I heard what happened at work today.",
    "Yes, I enjoyed the concert last night.",
    "Yes, I studied for the exam.",
    "Yes, I called my mom on her birthday.",
    "Yes, I paid the bills on time.",
    "Yes, I cleaned up the kitchen before going to bed.",
    "Yes, I took my medicine this morning.",
    "He was late because he overslept.",
    "The cake didn't rise because the oven temperature was too low.",
    "They cancelled the concert because the venue was damaged in a storm.",
    "She was crying because her pet had died.",
    "The building collapsed because of a major earthquake.",
    "He was fired because he consistently missed deadlines.",
    "The plane crashed because of a mechanical failure.",
    "The party was a disaster because the host didn't send out invitations.",
    "The company went bankrupt because of the economic downturn.",
    "She was arrested because she was caught driving under the influence.",
    "That woman I was talking to earlier was my neighbor.",
    "I invited all of my closest friends to the party.",
    "Sir Edmund Hillary was the first person to climb Mount Everest.",
    "I hired a web developer to build my company's website.",
    "George W. Bush was the president before Barack Obama.",
    "I voted for the Democratic candidate in the last election.",
    "Harper Lee was the author of 'To Kill a Mockingbird'.",
    "I saw my friend from college at the movie theater last night.",
    "Freddie Mercury was the lead singer of Queen.",
    "I lent my car to my brother for the weekend.",
    "    I was sleeping when the earthquake hit.",
    "I had oatmeal and coffee for breakfast this morning.",
    "The winning lottery numbers last week were 5, 12, 22, 32, 39, and 45.",
    "I thought the new Star Wars movie was entertaining but predictable.",
    "The lyrics to that song we heard earlier were 'I can't help falling in love with you'.",
    "I learned about the history of the Roman Empire in school today.",
    "The main points of the presentation were the company's revenue growth and new product launch.",
    "I packed sunscreen, a bathing suit, and a good book for my vacation.",
    "The results of the blood test showed that my cholesterol levels were normal.",
    "I bought bread, milk, eggs, and bananas at the grocery store.",
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _showNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      if (_currentQuestionIndex >= _questions.length) {
        _currentQuestionIndex = 0;
      }
    });
  }

  void _submitAnswer(String answer) async {
    /*if (_questions[_currentQuestionIndex]) {
      await playLocalAsset();
      if (_playerOneTurn) {
        setState(() {
          _playerOneScore++;
        });
      } else {
        setState(() {
          _playerTwoScore++;
        });
      }
    }*/
    _showNextQuestion();
  }

  bool isAwaitingAnswer = false;
  bool _isButton1Pressed = false;
  bool _isButton2Pressed = false;

  void reset() {
    isAwaitingAnswer = false;
    _isButton1Pressed = false;
    _isButton2Pressed = false;
  }

  Random random = Random();
  void _handleButton1Pressed() {
    if (isAwaitingAnswer) {
      if (_isButton1Pressed) {
        _playerOneScore++;
        reset();
        _currentQuestionIndex = random.nextInt(_questions.length);
      } else {
        reset();
      }
      return;
    }
    if (!_isButton2Pressed) {
      //_audioCache.play('button_sound.mp3');
      setState(() {
        _isButton1Pressed = true;
        isAwaitingAnswer = true;
      });
    }
  }

  void _handleButton2Pressed() {
    if (isAwaitingAnswer) {
      if (_isButton2Pressed) {
        _playerTwoScore++;
        reset();
        _currentQuestionIndex = random.nextInt(_questions.length);
      } else {
        reset();
      }
      return;
    }
    if (!_isButton1Pressed) {
      setState(() {
        _isButton2Pressed = true;
        isAwaitingAnswer = true;
      });
    }
  }

  IconData returnIcon(int player) {
    if (isAwaitingAnswer) if (player == 1) {
      if (_isButton1Pressed) {
        return Icons.check;
      }
      return Icons.close;
    } else {
      if (player == 2) {
        if (_isButton2Pressed) {
          return Icons.check;
        }
        return Icons.close;
      }
    }
    return Icons.bolt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Feud Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _questions[_currentQuestionIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Player 1: $_playerOneScore',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Player 2: $_playerTwoScore',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: 100,
                    onPressed: () {
                      setState(() {
                        _handleButton1Pressed();
                      });
                    },
                    icon: Icon(returnIcon(1)),
                    color: _isButton1Pressed ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: IconButton(
                    iconSize: 100,
                    onPressed: () {
                      setState(() {
                        _handleButton2Pressed();
                      });
                    },
                    icon: Icon(returnIcon(2)),
                    color: _isButton2Pressed ? Colors.green : Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
