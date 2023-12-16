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
            reviews: reviews);
      }).toList();
    });
  }

  static Future<void> addReview(String courseId, Review review) {
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayUnion([
            {
              'user_id': review.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ])
        })
        .then((value) => print("Review Added"))
        .catchError((error) => print("Failed to add review: $error"));
  }

  static Future<void> updateReview(
      String courseId, Review? oldReview, Review newReview) async {
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': oldReview!.userId,
              'rating': oldReview.rating,
              'review': oldReview.review,
            }
          ])
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
              ])
            })
            .then((value) => print("Review Added"))
            .catchError((error) => print("Failed to add review: $error")));
  }

  static Future<void> deleteReview(String courseId, Review? review) async {
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': review!.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ])
        })
        .then((value) => print("Review Deleted"))
        .catchError((error) => print("Failed to delete review: $error"));
  }
}
