import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
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
    if (_isReviewed()) {
      return _editReview();
    }
    return _addReview();
  }

  Widget _editReview() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: ReviewCard(review: widget.course.reviews[0]),
          ),
        ]));
  }

  Widget _addReview() {
    //return a rating component with a text box for reviews and a button to submit
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Rate this course',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 20,
            itemPadding: const EdgeInsets.symmetric(horizontal: 0.1),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Review',
              ),
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Submit'),
            ),
          )
        ]));
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
