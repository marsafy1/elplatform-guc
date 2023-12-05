import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/services/course_service.dart';

import '../../components/course/course_card.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CourseService _courseService = CourseService();
  List<Course> courses = [];
  @override
  void initState() {
    super.initState();
    _courseService.getCourses().then((value) {
      setState(() {
        courses = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Courses"),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return CourseCard(course: courses[index]);
                  },
                  itemCount: courses.length))
        ]));
  }
}
