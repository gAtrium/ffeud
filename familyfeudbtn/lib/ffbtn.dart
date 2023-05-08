import 'dart:async';
import 'dart:io';
import 'package:familyfeudbtn/socket_service.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class ButtonWidget extends StatefulWidget {
  //ButtonWidget());

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isButton1Pressed = false;
  bool _isButton2Pressed = false;

  void _handleButton1Pressed() {
    if (!_isButton2Pressed) {
      //_audioCache.play('button_sound.mp3');
      setState(() {
        _isButton1Pressed = true;
      });
      Timer(Duration(seconds: 5), () {
        setState(() {
          _isButton1Pressed = false;
        });
      });
    }
  }

  void _handleButton2Pressed() {
    if (!_isButton1Pressed) {
      //_audioCache.play('button_sound.mp3');
      setState(() {
        _isButton2Pressed = true;
      });
      Timer(Duration(seconds: 5), () {
        setState(() {
          _isButton2Pressed = false;
        });
      });
    }
  }

  void _handleButtonPressed() {
    if (!_isButton2Pressed) {
      //_audioCache.play('button_sound.mp3');
      setState(() {
        _isButton2Pressed = true;
      });
      Timer(Duration(seconds: 5), () {
        setState(() {
          _isButton2Pressed = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //_audioCache.load('button_sound.mp3');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<SocketProvider>(
      builder: (context, socketProvider, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                iconSize: 100,
                onPressed: () {
                  if (!_isButton2Pressed) {
                    //_audioCache.play('button_sound.mp3');
                    setState(() {
                      _isButton2Pressed = true;
                      socketProvider.pressTheButton();
                    });
                    Timer(Duration(seconds: 5), () {
                      setState(() {
                        _isButton2Pressed = false;
                      });
                    });
                  }
                },
                icon: Icon(Icons.bolt_sharp),
                color: _isButton2Pressed ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
