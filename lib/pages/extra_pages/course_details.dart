import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/services/course_service.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key});
  @override
  _CourseDetails createState() => _CourseDetails();
}

class _CourseDetails extends State<CourseDetails> {
  final CourseService _courseService = CourseService();
  Course course = Course(id: "", title: "", description: "", photoUrl: "");

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final courseId = routeArgs['id'];
    _courseService.getCourseById(courseId).then((value) {
      setState(() {
        course = value;
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(course.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(course.photoUrl),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              CourseDescription(description: course.description),
            ],
          ),
        ));
  }
}

class CourseDescription extends StatefulWidget {
  final String description;
  const CourseDescription({required this.description, super.key});
  @override
  State<CourseDescription> createState() {
    return _CourseDescription();
  }
}

class _CourseDescription extends State<CourseDescription> {
  int maxLines = 3;
  String buttonText = "Show More";
  _CourseDescription();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            widget.description,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                maxLines = maxLines == 3 ? 100000 : 3;
                buttonText =
                    buttonText == "Show More" ? "Show Less" : "Show More";
              });
            },
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
