import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/instructor_card.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class Instructors extends StatelessWidget {
  const Instructors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("$appName - Instructors"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return InstructorCard(
            instructorName: "Abdelrahman Elsalh",
            instructorRating: 4.3,
          );
        },
      ),
    );
  }
}
