//stateless widget that displays the course card based on Course model
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function(Course) onTap;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(course),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                course.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                course.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                course.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
