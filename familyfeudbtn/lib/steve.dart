import 'package:familyfeudbtn/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Steve extends StatefulWidget {
  @override
  _SteveState createState() => _SteveState();
}

class _SteveState extends State<Steve> {
  String _text = '';

  void _updateText(String newText) {
    setState(() {
      _text = newText;
    });
  }

  final inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
        builder: (context, socketProvider, child) => Scaffold(
              appBar: AppBar(
                title: Text('Host app'),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        labelText: 'Check you answer here',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Text input: $_text'),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            socketProvider.checkAnswer(inputController.text);
                            inputController.clear();
                          },
                          child: Text('Check the answer'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            socketProvider.switchToHostOnly();
                          },
                          child: Text('Switch to host only mode'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            socketProvider.revealAll();
                          },
                          child: Text('Reveal Everything'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            socketProvider.nextQuestion();
                          },
                          child: Text('Next Question'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
