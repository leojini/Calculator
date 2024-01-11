import 'package:calculator/data/stream_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:calculator/data/calc_data.dart';
import 'package:calculator/data/stream_data.dart';
import 'dart:async';

class CalcButton {
  final CalcType type;
  final StreamController streamController;
  final _textStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  CalcButton({required this.type, required this.streamController});

  Widget createButton() {
    return Container(
      color: Colors.yellow,
      width: 70,
      height: 70,
      child: TextButton(
        child: Text(type.title, style: _textStyle),
        onPressed: () {
          // debugPrint('type aa: ${type.title}');
          streamController.sink.add(StreamButtonData(type: StreamType.button, calcType: type));
        },
      ),
    );
  }
}