import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ServerSocket server;
  late Socket client;
  String message = 'Waiting for message...';

  @override
  void initState() {
    super.initState();
    startServer();
  }

  void startServer() async {
    try {
      server = await ServerSocket.bind('0.0.0.0', 8080);
      print('Listening on: ${server.address}:${server.port}');
      server.listen(
        (socket) {
          print(
              'Client connected: ${socket.remoteAddress.address}:${socket.remotePort}');
          client = socket;
          socket.listen(
            (data) {
              setState(() {
                print(data);
                print(utf8.decode(data));
                message = utf8.decode(data);
              });
            },
            onError: (error) {
              print(error);
              socket.destroy();
            },
            onDone: () {
              print('Client disconnected');
              socket.destroy();
            },
          );
        },
        onError: (error) {
          print(error);
          server.close();
        },
        onDone: () {
          print('Server stopped');
          server.close();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Socket Demo'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
