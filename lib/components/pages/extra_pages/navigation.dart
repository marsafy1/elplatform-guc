import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("elPlatform - Navigation"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Navigation"),
        ));
  }
}
