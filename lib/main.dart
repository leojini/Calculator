import 'package:flutter/material.dart';
import 'package:calculator/ui/home.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: HomeScreen(),
        )
      )
    )
  );
}

