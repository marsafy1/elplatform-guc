import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/course/course_reviews_list.dart';
import 'package:guc_swiss_knife/components/review/ratings_summary.dart';
import 'package:guc_swiss_knife/components/review/review_course.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseReviews extends StatefulWidget {
  final List<Review> reviews;
  final String courseId;
  const CourseReviews(
      {super.key, required this.reviews, required this.courseId});

  @override
  State<CourseReviews> createState() => _CourseReviews();
}

class _CourseReviews extends State<CourseReviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingsSummary(reviews: widget.reviews),
        CourseReviewsList(reviews: widget.reviews),
        ReviewCourse(
          reviews: widget.reviews,
          courseId: widget.courseId,
        ),
      ],
    );
  }
}
