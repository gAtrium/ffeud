import 'package:flutter/material.dart';

class FamilyFeudQuiz extends StatefulWidget {
  @override
  _FamilyFeudQuizState createState() => _FamilyFeudQuizState();
}

class _FamilyFeudQuizState extends State<FamilyFeudQuiz> {
  int _currentQuestionIndex = 0;
  int _strikes = 0;
  List<String> _questions = [
    'Name a type of fruit',
    'Name something you wear on your feet',
    'Name a popular pizza topping',
    'Name a country in Europe',
    'Name a common household appliance'
  ];
  List<List<String>> _answers = [
    ['Apple: 25', 'Banana: 20', 'Orange: 15', 'Grape: 10', 'Strawberry: 5'],
    ['Socks: 30', 'Shoes: 25', 'Sandals: 20', 'Boots: 15', 'Slippers: 10'],
    ['Pepperoni: 35', 'Mushroom: 25', 'Cheese: 20', 'Sausage: 15', 'Onion: 5'],
    [
      'France: 30',
      'Germany: 25',
      'Italy: 20',
      'Spain: 15',
      'United Kingdom: 10'
    ],
    [
      'Refrigerator: 30',
      'Microwave: 25',
      'Oven: 20',
      'Dishwasher: 15',
      'Toaster: 10'
    ]
  ];
  String _userGuess = '';
  List<String> _revealedAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Feud Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _questions[_currentQuestionIndex],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _revealedAnswers.isNotEmpty
                ? ListView.builder(
                    itemCount: _revealedAnswers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          _revealedAnswers[index],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) {
                        _userGuess = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your answer...',
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Strikes: $_strikes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _checkAnswer(_userGuess);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _checkAnswer(String guess) {
    if (_answers[_currentQuestionIndex].contains(guess)) {
      _revealedAnswers = _answers[_currentQuestionIndex];
    } else {
      _strikes++;
      if (_strikes >= 3) {
        _revealedAnswers = _answers[_currentQuestionIndex];
      }
    }
    setState(() {});
  }
}
