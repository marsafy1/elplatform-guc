import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/review.dart';

class AddReviewDialog extends StatefulWidget {
  final Review? initialReview;
  final Function(String review, int rating) onSubmit;
  final Function() onDelete;

  const AddReviewDialog(
      {super.key,
      this.initialReview,
      required this.onSubmit,
      required this.onDelete});

  @override
  _AddReviewDialog createState() => _AddReviewDialog();
}

class _AddReviewDialog extends State<AddReviewDialog> {
  late TextEditingController _controller;
  int _rating = 0;
  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialReview?.review ?? "");
    _rating = widget.initialReview?.rating.toInt() ?? 0;
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
              initialRating: widget.initialReview?.rating.toDouble() ?? 5,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 32,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating.toInt();
                });
              },
              ignoreGestures: false,
              updateOnDrag: true,
              glow: false,
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _controller,
              maxLines: null,
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
            widget.onSubmit(_controller.text, _rating);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        if (widget.initialReview != null)
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          )
      ],
    );
  }
}
