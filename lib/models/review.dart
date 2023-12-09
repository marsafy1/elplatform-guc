class Review {
  final String userId;
  final String? review;
  final double rating;

  Review({
    required this.userId,
    required this.rating,
    this.review,
  });
}
