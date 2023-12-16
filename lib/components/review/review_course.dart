import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/components/review/review_course_dialog.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ReviewCourse extends StatefulWidget {
  final Course course;
  const ReviewCourse({super.key, required this.course});

  @override
  State<ReviewCourse> createState() => _ReviewCourse();
}

class _ReviewCourse extends State<ReviewCourse> {
  late final AuthProvider _authProvider;
  late User user;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = _authProvider.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReviewed()) {
      return _editReview();
    }
    return _addReview();
  }

  Widget _editReview() {
    return Container(
        padding: const EdgeInsets.fromLTRB(4, 10, 10, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Your review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReviewCourseDialog(
                      initialReview: widget.course.reviews[0],
                      onSubmit: (String review, int rating) {},
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: ReviewCard(review: widget.course.reviews[0]),
          ),
        ]));
  }

  Widget _addReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReviewCourseDialog(
                  initialReview: null,
                  onSubmit: (String review, int rating) {},
                );
              },
            );
          },
          child: const Text(
            'Review Course ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            'Your review will help other students know more about this course.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  bool _isReviewed() {
    for (var review in widget.course.reviews) {
      if (review.userId == user.id) {
        return true;
      }
    }
    return false;
  }
}
