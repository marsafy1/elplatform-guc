import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Navigation"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Navigation"),
        ));
  }
}
