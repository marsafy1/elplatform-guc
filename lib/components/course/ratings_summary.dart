import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/review.dart';

class RatingsSummary extends StatelessWidget {
  final List<Review> reviews;
  const RatingsSummary({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    int oneStar = reviews.where((review) => review.rating == 1).length;
    int twoStar = reviews.where((review) => review.rating == 2).length;
    int threeStar = reviews.where((review) => review.rating == 3).length;
    int fourStar = reviews.where((review) => review.rating == 4).length;
    int fiveStar = reviews.where((review) => review.rating == 5).length;
    int total = reviews.length;
    double average =
        (oneStar + twoStar * 2 + threeStar * 3 + fourStar * 4 + fiveStar * 5) /
            total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            'Ratings ($total)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Row(children: [
          _buildAverageRating(average, context),
          Column(
            children: [
              _buildRow(fiveStar, total, 5, context),
              _buildRow(fourStar, total, 4, context),
              _buildRow(threeStar, total, 3, context),
              _buildRow(twoStar, total, 2, context),
              _buildRow(oneStar, total, 1, context),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildAverageRating(double average, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: [
            Text(
              average.toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Text(
              'out of 5',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(int count, int total, int rating, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBarIndicator(
          rating: rating.toDouble(),
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 5,
            child: LinearProgressIndicator(
              value: count / total,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ),
      ],
    );
  }
}
