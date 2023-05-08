import 'dart:async';
import 'dart:io';

import 'package:familyfeudbtn/ffbtn.dart';
import 'package:familyfeudbtn/steve.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ipController = TextEditingController();
  SocketProvider? _socket;
  late Socket socket;
  bool connected = false;

  @override
  void dispose() {
    if (_socket != null) {
      if (_socket!.isConnected) {
        _socket!.close();
      }
    }
    super.dispose();
  }

  void connectToServer() async {
    try {
      socket = await Socket.connect(ipController.text, 8080);
      setState(() {
        connected = true;
      });
      socket.listen((List<int> event) {
        // Do something with incoming data
      });
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }

  void closeConnection() {
    socket.close();
    setState(() {
      connected = false;
    });
  }

  void sendInteger(int value) {
    socket.add(value.toBytes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('IP Address'),
        ),
        body:
            Consumer<SocketProvider>(builder: (context, socketProvider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      hintText: 'Enter IP Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: socketProvider.isConnected
                        ? null
                        : () {
                            socketProvider.connect(ipController.text);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    socketProvider.identifier != "HARVEY"
                                        ? ButtonWidget()
                                        : Steve()));
                          },
                    child: Text(connected ? 'Connected' : 'Connect'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: socketProvider.isConnected
                        ? () {
                            socketProvider.close();
                          }
                        : null,
                    child: const Text('Close Connection'),
                  ),
                  const SizedBox(height: 21),
                  const Text("Role for this device"),
                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButton(
                      value: socketProvider.identifier,
                      items: ["RED", "BLU", "GRN", "HARVEY"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null) socketProvider.identifier = value;
                        });
                      })
                ],
              ),
            ),
          );

          return child!;
        }));
  }
}

extension IntToBytes on int {
  List<int> toBytes() => [this >> 24, this >> 16, this >> 8, this];
}
