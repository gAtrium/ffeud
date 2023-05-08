import 'package:familyfeud/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'net_get_ip.dart';
import 'feud_question.dart';

Widget _buildBox(String text, bool _isDone) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isDone
              ? const Icon(Icons.check_circle, color: Colors.green, size: 48.0)
              : const SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
          const SizedBox(height: 8.0),
          Text(text),
        ],
      ),
    ),
  );
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  SocketService? _socketService;
  @override
  String serverIP = "";

  void setServerIP() async {
    String ip = await getIP();
    setState(() {
      serverIP = ip;
    });
  }

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
    _socketService!.serve();
    setServerIP();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Feud'),
      ),
      body: Center(child:
          Consumer<SocketService>(builder: (context, socketService, child) {
        socketService.awaitingContext = context;
        return Center(
            child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(serverIP.isEmpty
                      ? "Grabbing local wifi ip..."
                      : "Awaiting connection. Server IP: $serverIP"),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildBox("Red", socketService.redConnected),
                  _buildBox("Green", socketService.grnConnected),
                  _buildBox("Blue", socketService.bluConnected),
                  _buildBox("Host", socketService.harveyConnected),
                ],
              ),
            ),
          ],
        ));
      })),
    );
  }
}
