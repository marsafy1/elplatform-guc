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
  late Future<List<Course>> futureCourses;
  @override
  void initState() {
    super.initState();
    futureCourses = CourseService.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("$appName - Courses"),
        ),
        body: Column(children: [
          FutureBuilder(
            future: futureCourses,
            builder: (context, AsyncSnapshot<List<Course>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Course>? courses = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: courses!.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: courses[index]);
                    },
                  ),
                );
              }
            },
          ),
        ]));
  }
}
