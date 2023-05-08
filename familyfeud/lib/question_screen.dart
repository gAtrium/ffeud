import 'dart:async';

import 'package:familyfeud/net_get_ip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  final List<String> questions;
  final List<List<String>> answers;
  final List<List<int>> popularities;

  QuestionScreen(
      {required this.questions,
      required this.answers,
      required this.popularities});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  List<String> _revealedAnswers = [];
  int _strikes = 0;
  TextEditingController _textController = TextEditingController();
  bool state = false; //false = button press

  Color containerIndicator = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(builder: (context, socketService, child) {
      //Process commands
      for (int i = 0; i < socketService.commandQueue.length; i++) {
        List<String> command =
            socketService.commandQueue.removeFirst().trim().split(' ');
        if (command.length > 0) {
          switch (command[0]) {
            case "BTNPRESS":
              {
                if (!state) {
                  state = true;
                  if (command.length >= 2) {
                    switch (command[1]) {
                      case "RED":
                        {
                          containerIndicator = Colors.red.shade500;
                          break;
                        }
                      case "BLU":
                        {
                          containerIndicator = Colors.blue.shade500;

                          break;
                        }
                      case "GRN":
                        {
                          containerIndicator = Colors.green.shade500;

                          break;
                        }
                    }
                  }
                  Timer(const Duration(seconds: 5), () {
                    state = false;
                    setState(() {
                      containerIndicator = Colors.transparent;
                    });
                  });
                }
                break;
              }
            case "CHECKANS":
              {
                if (command.length >= 2) {
                  _checkAnswer(command[1]);
                }
                break;
              }
            case "REVEALALL":
              {
                revealAll();

                break;
              }
            case "HOSTONLY":
              {
                state = true;
                break;
              }
            case "NEXTQUESTION":
              {
                _strikes = 0;

                nextQuestion();

                break;
              }
          }
        }
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Family Feud'),
        ),
        body: Column(
          children: [
            Container(
              color: containerIndicator,
              margin: const EdgeInsets.all(20),
              child: Text(
                widget.questions[_currentQuestionIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            state
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (String guess) {
                        _checkAnswer(guess);
                        _textController.clear();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your guess',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 40),
                itemCount: widget.answers[_currentQuestionIndex].length,
                itemBuilder: (context, index) {
                  String answer = widget.answers[_currentQuestionIndex][index];
                  String popularity = widget.popularities[_currentQuestionIndex]
                          [index]
                      .toString();
                  bool isRevealed =
                      _revealedAnswers.contains(answer) || _strikes == 3;
                  bool isGuessed = _revealedAnswers.contains(answer);
                  //!_revealedAnswers
                  //    .containsAll(widget.answers[_currentQuestionIndex]);
                  return AnswerTile(
                    answer: answer,
                    popularity: popularity,
                    isRevealed: isRevealed,
                    isGuessed: isGuessed,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void revealAll() {
    _revealedAnswers = widget.answers[_currentQuestionIndex];
  }

  void nextQuestion() {
    _currentQuestionIndex++;
    _revealedAnswers = [];
    _strikes = 0;
  }

  void _checkAnswer(String guess) {
    int ind = -1;
    for (int i = 0; i < widget.answers[_currentQuestionIndex].length; i++) {
      if (widget.answers[_currentQuestionIndex][i]
          .toLowerCase()
          .contains(guess.toLowerCase())) ind = i;
    }
    if (ind != -1) {
      _revealedAnswers.add(widget.answers[_currentQuestionIndex][ind]);
      if (_revealedAnswers.length ==
          widget.answers[_currentQuestionIndex].length) {
        _revealedAnswers = widget.answers[_currentQuestionIndex];
      }
    } else {
      _strikes++;
      if (_strikes >= 6 ||
          _revealedAnswers.length ==
              widget.answers[_currentQuestionIndex].length) {
        revealAll();
      }
    }
  }
}

class AnswerTile extends StatelessWidget {
  final String answer;
  final String popularity;
  final bool isRevealed;
  final bool isGuessed;
  final bool ispoopoo = true;

  AnswerTile({
    required this.answer,
    required this.popularity,
    required this.isRevealed,
    required this.isGuessed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ispoopoo
            ? Row(
                children: isGuessed
                    ? [
                        Expanded(
                          child: Text(
                            answer,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Positioned.fill(
                            child: Container(
                              color: const Color.fromARGB(255, 0, 255, 8)
                                  .withOpacity(0.2),
                              child: Text(
                                '$popularity',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ]
                    : [Container()],
              )
            : Stack(
                children: [
                  isRevealed
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                answer,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //const SizedBox(height: 1)
                            ],
                          ),
                        )
                      : Container(),
                  isGuessed
                      ? Positioned.fill(
                          child: Container(
                            color: const Color.fromARGB(255, 0, 255, 8)
                                .withOpacity(0.2),
                            child: Text(
                              'Popularity: $popularity',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ));
  }
}
