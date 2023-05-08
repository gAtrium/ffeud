import 'package:flutter/material.dart';

class FamilyFeudQuiz extends StatefulWidget {
  const FamilyFeudQuiz({super.key});

  @override
  _FamilyFeudQuizState createState() => _FamilyFeudQuizState();
}

class _FamilyFeudQuizState extends State<FamilyFeudQuiz> {
  int _currentQuestionIndex = 0;
  final List<String> _questions = [
    'Name a type of fruit',
    'Name something you wear on your feet',
    'Name a popular pizza topping',
    'Name a country in Europe',
    'Name a common household appliance'
  ];
  final List<List<String>> _answers = [
    ['Apple', 'Banana', 'Orange', 'Grape', 'Strawberry'],
    ['Socks', 'Shoes', 'Sandals', 'Boots', 'Slippers'],
    ['Pepperoni', 'Mushroom', 'Cheese', 'Sausage', 'Onion'],
    ['France', 'Germany', 'Italy', 'Spain', 'United Kingdom'],
    ['Refrigerator', 'Microwave', 'Oven', 'Dishwasher', 'Toaster']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Feud Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _questions[_currentQuestionIndex],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _answers[_currentQuestionIndex].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      _showResult(_answers[_currentQuestionIndex][index]);
                    },
                    child: Text(
                      _answers[_currentQuestionIndex][index],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showResult(String answer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: Text('Your answer: $answer'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Congratulations!'),
                        content: const Text('You have finished the quiz.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }
}
