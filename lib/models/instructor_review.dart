import 'package:guc_swiss_knife/models/review.dart';

class InstructorReview {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? faculty;
  final double? rating;
  final List<Review>? reviews;

  InstructorReview({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    this.faculty,
    this.rating = 5.0,
    this.reviews = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'faculty': faculty,
      'ratings_sum': rating! * reviews!.length.toDouble(),
      'reviews': reviews?.map((e) => e.toMap()).toList(),
    };
  }

  factory InstructorReview.fromMap(
      Map<String, dynamic> map, String documentId) {
    return InstructorReview(
      id: documentId,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      faculty: map['faculty'] as String?,
      rating: (map['ratings_sum'] as num? ?? 0.0) /
          ((map['reviews'] as List<dynamic>?)?.length.toDouble() ?? 1),
      reviews: (map['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
