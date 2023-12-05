import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/course.dart';

class CourseDetails extends StatelessWidget {
  final Course course = Course(
    id: '1',
    title: "Course 1",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    photoUrl: "https://picsum.photos/200/300",
  );
  CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
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
  final int maxLines;
  const CourseDescription(
      {required this.description, this.maxLines = 3, super.key});
  @override
  State<CourseDescription> createState() {
    return _CourseDescription();
  }
}

class _CourseDescription extends State<CourseDescription> {
  String description = "";
  int maxLines = 3;
  _CourseDescription();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            description,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Read More",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
