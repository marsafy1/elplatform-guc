import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/course/course_description.dart';
import 'package:guc_swiss_knife/components/course/course_reviews_list.dart';
import 'package:guc_swiss_knife/components/course/course_reviews.dart';
import 'package:guc_swiss_knife/components/review/ratings_summary.dart';
import 'package:guc_swiss_knife/components/review/review_course.dart';
import 'package:guc_swiss_knife/models/course.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Course>;
    final course = routeArgs['course'];

    return Scaffold(
        appBar: AppBar(
          title: Text(course!.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(course.photoUrl, context),
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
              CourseReviews(reviews: course.reviews, courseId: course.id),
            ],
          ),
        ));
  }

  Widget _buildImage(String photoUrl, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircularProgressIndicator(),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/Empty.png'),
            image: NetworkImage(photoUrl),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ),
      ],
    );
  }
}
