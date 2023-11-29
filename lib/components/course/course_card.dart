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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: InkWell(
        onTap: () => onTap(course),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  course.photoUrl,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            Column(
              children: [Text(course.title), Text(course.description)],
            )
          ],
        ),
      ),
    );
  }
}
