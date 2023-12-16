import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';

class InstructorCard extends StatelessWidget {
  User instructor;
  InstructorCard({Key? key, required this.instructor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text(instructor.firstName),
        subtitle: Text("${instructor.rating} ⭐"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, '/instructorDetails',
              arguments: instructor);
        },
      ),
    );
  }
}
