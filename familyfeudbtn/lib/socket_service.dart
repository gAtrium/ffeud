import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SocketProvider with ChangeNotifier {
  Socket? _socket;
  bool _isConnected = false;
  String identifier = "RED";
  //final String identifier = "BLU";
  //final String identifier = "GRN";
  //final String identifier = "HARVEY";

  Future<void> send(String str) async {
    _socket!.writeln(str);
    //await _socket!.flush();
  }

  Future<void> connect(String ip) async {
    try {
      _socket = await Socket.connect(ip, 8080);
      _isConnected = true;
      await send("ASSIGN $identifier");
      notifyListeners();
    } catch (e) {
      print(e);
      _isConnected = false;
      notifyListeners();
    }
  }

  void pressTheButton() async {
    await send("COMMAND $identifier BTNPRESS $identifier");
  }

  void checkAnswer(String answer) async {
    await send("COMMAND $identifier CHECKANS $answer");
  }

  void revealAll() async {
    await send("COMMAND $identifier REVEALALL");
  }

  void switchToHostOnly() async {
    await send("COMMAND $identifier HOSTONLY");
  }

  void nextQuestion() async {
    await send("COMMAND $identifier NEXTQUESTION");
  }

  void close() {
    if (_socket != null) {
      _isConnected = false;
      _socket!.close();
      _socket = null;
      notifyListeners();
    }
  }

  /*
    EVENT ARCHITECTURE
    btn #id connected // Client connection to main client
    btn #id pressed   // Client pressed the button
    harvey answer str // Show host sent an answer
   */
  void emitEvent() {}

  bool get isConnected => _isConnected;
}
