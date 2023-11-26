import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart' as constants;

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("${constants.appName} - About Us"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("About us"),
        ));
  }
}
