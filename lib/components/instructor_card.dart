import 'package:flutter/material.dart';

class InstructorCard extends StatelessWidget {
  final String instructorName;
  final double instructorRating;

  const InstructorCard(
      {Key? key, required this.instructorName, required this.instructorRating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text(instructorName),
        subtitle: Text("$instructorRating ⭐"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, '/instructorDetails', arguments: {
            'instructorName': instructorName,
            'instructorRating': instructorRating
          });
        },
      ),
    );
  }
}
