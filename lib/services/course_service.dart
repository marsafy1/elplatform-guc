import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseService {
  static final CollectionReference _coursesCollectionReference =
      FirebaseFirestore.instance.collection('courses');

  static Future<List<Course>> getCourses() {
    return _coursesCollectionReference.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        List<Review> reviews = (doc['reviews'] as List<dynamic>)
            .map((e) => Review(
                  rating: e['rating'] as int,
                  review: e['review'],
                  userId: e['user_id'],
                ))
            .toList();
        return Course(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            photoUrl: doc['photo_url'],
            reviews: reviews,
            averageRating:
                (doc['ratings_sum'] as num) / reviews.length.toDouble());
      }).toList();
    });
  }

  static Future<void> addReview(String? courseId, Review review) {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayUnion([
            {
              'user_id': review.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(review.rating),
        })
        .then((value) => print("Review Added"))
        .catchError((error) => print("Failed to add review: $error"));
  }

  static Future<void> updateReview(
      String? courseId, Review? oldReview, Review newReview) async {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': oldReview!.userId,
              'rating': oldReview.rating,
              'review': oldReview.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(-newReview.rating),
        })
        .then((value) => print("Review Removed"))
        .catchError((error) => print("Failed to remove review: $error"))
        .then((value) => _coursesCollectionReference
            .doc(courseId)
            .update({
              'reviews': FieldValue.arrayUnion([
                {
                  'user_id': newReview.userId,
                  'rating': newReview.rating,
                  'review': newReview.review,
                }
              ]),
              'ratings_sum': FieldValue.increment(newReview.rating),
            })
            .then((value) => print("Review Added"))
            .catchError((error) => print("Failed to add review: $error")));
  }

  static Future<void> deleteReview(String? courseId, Review? review) async {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': review!.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(-review.rating),
        })
        .then((value) => print("Review Deleted"))
        .catchError((error) => print("Failed to delete review: $error"));
  }
}
