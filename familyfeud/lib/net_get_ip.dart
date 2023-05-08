import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:familyfeud/question_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'feud_question.dart';

class CommandQueue {
  final List<String> _commands = [];

  void pushCommand(String command) {
    _commands.add(command);
  }

  String? popCommand() {
    if (_commands.isNotEmpty) {
      return _commands.removeAt(0);
    } else {
      return null;
    }
  }
}

class ClientHandler {
  Socket client;
  String? assignedVariable;
  ServerSocket? serverSocket;

  ClientHandler(this.client, this.assignedVariable);
  Queue<String> commandQueue = Queue<String>();

  void handleData(String data) {
    // add data to command queue
    commandQueue.add(data);
  }

  void sendData(String data) {
    print(data);
  }
}

class SocketService with ChangeNotifier {
  bool inited = false;
  ServerSocket? serverSocket;
  BuildContext? awaitingContext;
  List<ClientHandler> clients = [];
  Map<String, ClientHandler?> assignedVariables = {
    'RED': null,
    'BLU': null,
    'GRN': null,
    'HARVEY': null,
  };

  bool get redConnected => assignedVariables['RED'] != null;

  bool get bluConnected => assignedVariables['BLU'] != null;

  bool get grnConnected => assignedVariables['GRN'] != null;

  bool get harveyConnected => assignedVariables['HARVEY'] != null;

  List<String> Commands = [];
  Queue<String> commandQueue = Queue<String>();

  void handleCommand(String data, ClientHandler clientHandler) {
    var parts = data.split(' ');
    if (parts.length == 2 && parts[0] == 'ASSIGN') {
      // assign variable to client
      String variableName = parts[1];
      variableName = variableName.trim();
      if (assignedVariables.containsKey(variableName)) {
        if (assignedVariables[variableName] != null) {
          // variable already assigned
          clientHandler.sendData('Variable $variableName is already assigned');
        } else {
          assignedVariables[variableName] = clientHandler;
          clientHandler.assignedVariable = variableName;
          clientHandler.sendData('Assigned to $variableName');
        }
        notifyListeners();
      } else {
        // unknown variable
        clientHandler.sendData('Unknown variable: $variableName');
      }
    } else if (parts.length >= 2 && parts[0] == 'COMMAND') {
      // send command to assigned client
      var variableName = parts[1];
      if (assignedVariables.containsKey(variableName)) {
        var client = assignedVariables[variableName];
        if (client != null) {
          var command = parts.sublist(2).join(' ');
          //client.sendData('$variableName: $command');
          commandQueue.add(command);
          notifyListeners();
        } else {
          clientHandler.sendData('Variable $variableName is not assigned');
        }
      } else {
        // unknown variable
        clientHandler.sendData('Unknown variable: $variableName');
      }
    } else {
      // unknown command
      clientHandler.sendData('Unknown command: $data');
    }
  }

  void processCommands() async {
    while (true) {
      if (commandQueue.isNotEmpty) {
        var command = commandQueue.removeFirst();
        // process command
        print('Processing command: $command');
      }
    }
  }

  Future<void> serve() async {
    serverSocket = await ServerSocket.bind('0.0.0.0', 8080);
    print('Server started on port 8080');
    serverSocket?.listen((socket) {
      print(
          'Client connected from: ${socket.remoteAddress.address}:${socket.remotePort}');
      var clientHandler = ClientHandler(socket, null);
      clients.add(clientHandler);
      socket.listen((data) {
        handleCommand(String.fromCharCodes(data), clientHandler);
        if (isConnected && !inited) {
          inited = true;
          Navigator.of(awaitingContext!).push(MaterialPageRoute(
            builder: (context) => QuestionScreen(
              questions: [Question1_question, emergency_question],
              answers: [Question1_answers, emergency_answers],
              popularities: [Question1_popularities, emergency_popularities],
            ),
          ));
        }
      }, onError: (error) {
        print('Error: $error');
        clients.remove(clientHandler);
      }, onDone: () {
        print('Client disconnected');
        assignedVariables[clientHandler.assignedVariable!] = null;
        clients.remove(clientHandler);
        notifyListeners();
      });
    });
    // start processing commands
  }

  void sendMessage(String message) {}

  void disconnect() {
    notifyListeners();
  }

  //bool get isConnected =>
  //    redConnected && bluConnected && grnConnected && harveyConnected;
  bool get isConnected => redConnected && harveyConnected;
}

Future<String> getIP() async {
  try {
    List<NetworkInterface> interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      if (interface.name.contains("wl")) {
        // Use the interface name that corresponds to your Wi-Fi interface
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
    }
  } catch (e) {
    print("Error getting IP address: $e");
  }
  return "";
}
