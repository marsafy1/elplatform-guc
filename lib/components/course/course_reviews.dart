import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseReviews extends StatelessWidget {
  final List<Review> reviews;
  const CourseReviews({super.key, required this.reviews});
  @override
  Widget build(BuildContext context) {
    //return a row that is horizontally scrollable
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Row(
          children: [
            for (var review in reviews)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: ReviewCard(review: review),
              ),
          ],
        ),
      ),
    );
  }
}
