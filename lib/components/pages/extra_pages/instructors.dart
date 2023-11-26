import 'package:flutter/material.dart';

class Instructors extends StatelessWidget {
  const Instructors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("elPlatform - Instructors"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Instructors"),
        ));
  }
}
