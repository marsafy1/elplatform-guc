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
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircularProgressIndicator(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/Empty.png'),
                      image: NetworkImage(course.photoUrl),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
            CourseCardDetails(course: course)
          ],
        ),
      ),
    );
  }
}

class CourseCardDetails extends StatelessWidget {
  final Course course;
  const CourseCardDetails({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 5),
            child: Text(
              course.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            )),
        Text(
          course.description,
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
