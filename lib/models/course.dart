import 'package:guc_swiss_knife/models/review.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final double averageRating;
  final List<Review> reviews;
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.reviews,
    required this.averageRating,
  });
}
