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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ratings Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Average Rating: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                average.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 10),
              RatingBarIndicator(
                rating: average,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          _buildRow(oneStar, 1),
          _buildRow(twoStar, 2),
          _buildRow(threeStar, 3),
          _buildRow(fourStar, 4),
          _buildRow(fiveStar, 5),
        ],
      ),
    );
  }

  Widget _buildRow(int count, int rating) {
    return Row(
      children: [
        const Text(
          '5 Star: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 10),
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
      ],
    );
  }
}
