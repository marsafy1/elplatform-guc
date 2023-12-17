import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/review/ratings_summary.dart';
import 'package:guc_swiss_knife/components/review/add_review.dart';
import 'package:guc_swiss_knife/components/review/reviews_list.dart';
import 'package:guc_swiss_knife/models/review.dart';

class InstructorReviews extends StatefulWidget {
  List<Review> reviews;
  final String instructorId;
  InstructorReviews(
      {super.key, required this.reviews, required this.instructorId});

  @override
  State<InstructorReviews> createState() => _InstructorReviews();
}

class _InstructorReviews extends State<InstructorReviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingsSummary(reviews: widget.reviews),
        ReviewsList(reviews: widget.reviews),
        AddReview(
          reviews: widget.reviews,
          courseId: null,
          instructorId: widget.instructorId,
          setReviews: setReviews,
        ),
      ],
    );
  }

  void setReviews(List<Review> reviews) {
    setState(() {
      widget.reviews = reviews;
    });
  }
}
