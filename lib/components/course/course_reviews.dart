import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseReviews extends StatelessWidget {
  final List<Review> reviews;
  const CourseReviews({super.key, required this.reviews});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...reviews.map((review) => ReviewCard(review: review)).toList()
      ],
    );
  }
}
