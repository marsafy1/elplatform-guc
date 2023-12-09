import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/review.dart';

class ReviewDetails extends StatelessWidget {
  final Review review;
  const ReviewDetails({super.key, required this.review});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Review"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(review.review),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
