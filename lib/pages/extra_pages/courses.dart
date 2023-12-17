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
  TextEditingController searchController = TextEditingController();

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
                List<Course>? filteredCourses = courses!
                    .where((course) => course.title
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
                for (int i = 0; i < 10; i++) {
                  filteredCourses.add(filteredCourses[0]);
                }
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          // Implement your search logic here
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search courses...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: filteredCourses[index]);
                      },
                    ),
                  ),
                ]);
              }
            },
          ),
        ]));
  }
}
