import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';

class InstructorService {
  static final CollectionReference<Map<String, dynamic>>
      _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  static Stream<List<User>> fetchInstructors() {
    Stream<List<User>> fetchedInstructors = _usersCollectionReference
        .where("user_type", isEqualTo: "instructor")
        .snapshots()
        .asyncMap((snapshot) async {
      List<User> instructors = [];
      for (var doc in snapshot.docs) {
        User instructor = User.fromMap(doc.data(), doc.id);
        instructors.add(instructor);
      }
      return instructors;
    });
    return fetchedInstructors;
  }

  static Future<void> addReview(String? instructorId, Review review) {
    if (instructorId == null) {
      return Future.error('Instructor ID is null');
    }
    return _usersCollectionReference
        .doc(instructorId)
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
      String? instructorId, Review? oldReview, Review newReview) async {
    if (instructorId == null) {
      return Future.error('Course ID is null');
    }
    return _usersCollectionReference
        .doc(instructorId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': oldReview!.userId,
              'rating': oldReview.rating,
              'review': oldReview.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(-oldReview.rating),
        })
        .then((value) => print("Review Removed"))
        .catchError((error) => print("Failed to remove review: $error"))
        .then((value) => _usersCollectionReference
            .doc(instructorId)
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

  static Future<void> deleteReview(String? instructorId, Review? review) async {
    if (instructorId == null) {
      return Future.error('Course ID is null');
    }
    return _usersCollectionReference
        .doc(instructorId)
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
