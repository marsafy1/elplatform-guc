import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';

class InstructorDetails extends StatelessWidget {
  const InstructorDetails({Key? key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['instructorName']),
      ),
      body: Center(
        child: Text(args['instructorRating'].toString()),
      ),
    );
  }
}
