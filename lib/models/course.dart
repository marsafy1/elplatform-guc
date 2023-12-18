import 'package:guc_swiss_knife/models/review.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final double averageRating;
  final List<Review> reviews;
  Course({
    this.id = '',
    required this.title,
    required this.description,
    this.photoUrl =
        'https://bub.bh/wp-content/uploads/2018/02/image-placeholder.jpg',
    this.reviews = const [],
    this.averageRating = 5.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'photo_url': photoUrl,
      'reviews': reviews.map((e) => e.toMap()).toList(),
      'ratings_sum': averageRating * reviews.length.toDouble(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      title: map['title'],
      description: map['description'],
      photoUrl: map['photo_url'],
      reviews: (map['reviews'] as List<dynamic>)
          .map((e) => Review(
                rating: e['rating'] as int,
                review: e['review'],
                userId: e['user_id'],
              ))
          .toList(),
      averageRating: (map['ratings_sum'] as num) /
          (map['reviews'] as List<dynamic>).length.toDouble(),
    );
  }
}
