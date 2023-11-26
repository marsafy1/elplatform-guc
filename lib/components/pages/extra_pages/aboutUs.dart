import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("elPlatform - About Us"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("About us"),
        ));
  }
}
