import 'package:flutter/material.dart';

class Courses extends StatelessWidget {
  const Courses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("elPlatform - Courses"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Courses"),
        ));
  }
}
