import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/course/course_description.dart';
import 'package:guc_swiss_knife/components/course/course_reviews.dart';
import 'package:guc_swiss_knife/components/course/ratings_summary.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/models/review.dart';

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
              Stack(
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
              RatingsSummary(reviews: course.reviews),
              CourseReviews(reviews: course.reviews)
            ],
          ),
        ));
  }
}
