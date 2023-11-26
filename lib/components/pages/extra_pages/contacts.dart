import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("elPlatform - Contacts"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Contacts"),
        ));
  }
}
