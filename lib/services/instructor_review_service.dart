import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/instructor_review.dart';
import 'package:guc_swiss_knife/models/review.dart';

class InstructorReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<InstructorReview>> fetchInstructorReview() {
    Stream<List<InstructorReview>> fetchedContacts = _firestore
        .collection("instructor_review")
        .snapshots()
        .asyncMap((snapshot) async {
      List<InstructorReview> contacts = [];
      for (var doc in snapshot.docs) {
        InstructorReview contact = InstructorReview.fromMap(doc.data(), doc.id);
        contacts.add(contact);
      }
      return contacts;
    });
    return fetchedContacts;
  }

  Future<void> addInstructorReview(InstructorReview instructorReview) async {
    print("hello");
    print(instructorReview.toMap());
    await _firestore
        .collection("instructor_review")
        .add(instructorReview.toMap());
  }

  Future<void> deleteInstructorReview(String id) async {
    await _firestore.collection("instructor_review").doc(id).delete();
  }

  Future<void> addReview(String? instructorId, Review review) {
    if (instructorId == null) {
      return Future.error('Instructor ID is null');
    }
    return _firestore
        .collection("instructor_review")
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

  Future<void> updateReview(
      String? instructorId, Review? oldReview, Review newReview) async {
    if (instructorId == null) {
      return Future.error('Course ID is null');
    }
    return _firestore
        .collection("instructor_review")
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
        .then((value) => _firestore
            .collection("instructor_review")
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

  Future<void> deleteReview(String? instructorId, Review? review) async {
    if (instructorId == null) {
      return Future.error('Course ID is null');
    }
    return _firestore
        .collection("instructor_review")
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
