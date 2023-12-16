class Review {
  final String userId;
  final String? review;
  final int rating;

  Review({
    required this.userId,
    required this.rating,
    this.review,
  });
}
