import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/course/course_card.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/course.dart';

class Courses extends StatelessWidget {
  final List<Course> courses = [
    Course(
      id: '1',
      title: "Course 1",
      description: "This is course 1",
      photoUrl: "https://picsum.photos/50/50",
    ),
    Course(
      id: '2',
      title: "Course 2",
      description: "This is course 2",
      photoUrl: "https://picsum.photos/200/300",
    ),
    Course(
      id: '3',
      title: "Course 3",
      description: "This is course 3",
      photoUrl: "https://picsum.photos/200/300",
    ),
    Course(
      id: '4',
      title: "Course 4",
      description: "This is course 4",
      photoUrl: "https://picsum.photos/200/300",
    ),
    Course(
      id: '5',
      title: "Course 5",
      description: "This is course 5",
      photoUrl: "https://picsum.photos/200/300",
    ),
    Course(
      id: '1',
      title: "Course 6",
      description: "This is course 6",
      photoUrl: "https://picsum.photos/200/300",
    ),
  ];
  Courses({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Courses"),
        ),
        body: CourseCard(
          course: courses[0],
          onTap: (course) {},
        ));
  }
}
