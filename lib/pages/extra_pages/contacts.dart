import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Contacts"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Contacts"),
        ));
  }
}
