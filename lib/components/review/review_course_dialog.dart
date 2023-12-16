import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/review.dart';

class ReviewCourseDialog extends StatefulWidget {
  final Review? initialReview;
  final Function(String review, int rating) onSubmit;

  ReviewCourseDialog({this.initialReview, required this.onSubmit});

  @override
  _ReviewCourseDialog createState() => _ReviewCourseDialog();
}

class _ReviewCourseDialog extends State<ReviewCourseDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialReview?.review ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(widget.initialReview == null ? 'Add review' : 'Edit review'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: widget.initialReview?.rating.toDouble() ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 32,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
              ignoreGestures: false,
              updateOnDrag: true,
              glow: false,
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _controller,
              maxLines: null, // Set to null for unlimited lines
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter review',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
