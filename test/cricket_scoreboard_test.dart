import 'package:cricket_scoreboard/cricket_scoreboard.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Package Demo")),
        body: const Center(
          child: CustomScoreBoard(),
        ),
      ),
    );
  }
}
