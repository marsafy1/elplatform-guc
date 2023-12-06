class Review {
  final String userId;
  final String review;
  final double? rating;

  Review({
    required this.userId,
    required this.review,
    this.rating,
  });
}
