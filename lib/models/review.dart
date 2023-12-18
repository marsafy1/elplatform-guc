class Review {
  final String userId;
  final String? review;
  final int rating;

  Review({
    required this.userId,
    required this.rating,
    this.review,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['user_id'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      review: map['review'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'rating': rating,
      'review': review,
    };
  }
}
