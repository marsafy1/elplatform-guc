import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/components/review/review_course_dialog.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import 'package:provider/provider.dart';

class ReviewCourse extends StatefulWidget {
  final List<Review> reviews;
  final String courseId;
  const ReviewCourse(
      {super.key, required this.reviews, required this.courseId});

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
    Review? oldReview = _getOldReview();
    if (oldReview != null) {
      return _editReview(oldReview);
    }
    return _addReview();
  }

  Widget _editReview(Review? oldReview) {
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
                      initialReview: oldReview,
                      onSubmit: _onSubmit,
                      onDelete: _onDelete,
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: ReviewCard(review: oldReview!),
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
                  onSubmit: _onSubmit,
                  onDelete: _onDelete,
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

  Review? _getOldReview() {
    for (Review review in widget.reviews) {
      if (review.userId == user.id) {
        return review;
      }
    }
    return null;
  }

  void _onSubmit(String review, int rating) async {
    Review reviewObj = Review(
      userId: user.id,
      rating: rating,
      review: review,
    );
    if (_getOldReview() == null) {
      await CourseService.addReview(widget.courseId, reviewObj);
    } else {
      await CourseService.updateReview(
          widget.courseId, _getOldReview(), reviewObj);
    }
    setState(() {
      widget.reviews.removeWhere((element) => element.userId == user.id);
      widget.reviews.add(reviewObj);
    });
  }

  void _onDelete() async {
    await CourseService.deleteReview(widget.courseId, _getOldReview());
    setState(() {
      widget.reviews.removeWhere((element) => element.userId == user.id);
    });
  }
}
