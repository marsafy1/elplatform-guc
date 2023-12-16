import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';

class InstructorDetails extends StatelessWidget {
  const InstructorDetails({Key? key});

  @override
  Widget build(BuildContext context) {
    User instructor = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text(instructor.firstName),
      ),
      body: Center(
        child: Text(instructor.rating.toString()  ),
      ),
    );
  }
}
