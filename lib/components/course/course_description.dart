import 'package:flutter/material.dart';

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
