import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/components/review/add_review_dialog.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import 'package:guc_swiss_knife/services/instructor_review_service.dart';
import 'package:guc_swiss_knife/services/instructor_service.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  final List<Review> reviews;
  final String? courseId;
  final String? instructorId;
  final Function setReviews;
  const AddReview(
      {super.key,
      required this.reviews,
      required this.courseId,
      required this.setReviews,
      this.instructorId});

  @override
  State<AddReview> createState() => _AddReview();
}

class _AddReview extends State<AddReview> {
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
                    return AddReviewDialog(
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
        Row(children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddReviewDialog(
                    initialReview: null,
                    onSubmit: _onSubmit,
                    onDelete: _onDelete,
                  );
                },
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 4),
              child: Text(
                widget.instructorId == null
                    ? 'Review Course'
                    : "Review Instructor",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            widget.instructorId == null
                ? 'Your review will help other students know more about this course.'
                : 'Your review will help other students know more about this instructor.',
            style: const TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.start,
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

  InstructorReviewService instructorReviewService = InstructorReviewService();
  void _onSubmit(String review, int rating) async {
    Review reviewObj = Review(
      userId: user.id,
      rating: rating,
      review: review,
    );
    if (_getOldReview() == null) {
      if (widget.courseId != null) {
        await CourseService.addReview(widget.courseId, reviewObj);
      } else {
        await instructorReviewService.addReview(widget.instructorId, reviewObj);
      }
    } else {
      if (widget.courseId != null) {
        await CourseService.updateReview(
            widget.courseId, _getOldReview(), reviewObj);
      } else {
        await instructorReviewService.updateReview(
            widget.instructorId, _getOldReview(), reviewObj);
      }
    }
    setState(() {
      widget.reviews.removeWhere((element) => element.userId == user.id);
      widget.reviews.add(reviewObj);
      widget.setReviews(widget.reviews);
    });
  }

  void _onDelete() async {
    if (widget.courseId != null) {
      await CourseService.deleteReview(widget.courseId, _getOldReview());
    } else {
      await instructorReviewService.deleteReview(
          widget.instructorId, _getOldReview());
    }
    setState(() {
      widget.reviews.removeWhere((element) => element.userId == user.id);
      widget.setReviews(widget.reviews);
    });
  }
}
