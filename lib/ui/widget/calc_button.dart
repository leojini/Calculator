import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:calculator/data/calc_data.dart';
import 'dart:async';

typedef PressedButtonCb = void Function(CalcType);

class CalcButton {
  final CalcType type;
  final _textStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  CalcButton(this.type);

  Widget createButton(PressedButtonCb callback) {
    return Container(
      color: Colors.yellow,
      width: 70,
      height: 70,
      child: TextButton(
        child: Text(type.title, style: _textStyle),
        onPressed: () {
          // debugPrint('type aa: ${type.title}');
          callback(type);
        },
      ),
    );
  }
}