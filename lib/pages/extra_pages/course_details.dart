import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Course Details"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Course Details"),
        ));
  }
}
