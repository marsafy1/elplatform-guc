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

  static Future<void> updateReview(String courseId, Review newReview) async {
    try {
      DocumentReference documentReference =
          _coursesCollectionReference.doc(courseId);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        List<Review> reviews = (documentSnapshot['reviews'] as List<dynamic>)
            .map((e) => Review(
                  rating: e['rating'] as int,
                  review: e['review'],
                  userId: e['user_id'],
                ))
            .toList();
        reviews.removeWhere((element) => element.userId == newReview.userId);
        reviews.add(newReview);
        await documentReference.update({'your_array_field': reviews});
      } else {
        print('Document with ID $courseId does not exist.');
      }
    } catch (e) {
      print('Error updating array element: $e');
    }
  }

  static Future<void> deleteReview(String courseId, Review? review) async {
    try {
      DocumentReference documentReference =
          _coursesCollectionReference.doc(courseId);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        List<Review> reviews = (documentSnapshot['reviews'] as List<dynamic>)
            .map((e) => Review(
                  rating: e['rating'] as int,
                  review: e['review'],
                  userId: e['user_id'],
                ))
            .toList();
        reviews.removeWhere((element) => element.userId == review!.userId);
        await documentReference.update({'your_array_field': reviews});
      } else {
        print('Document with ID $courseId does not exist.');
      }
    } catch (e) {
      print('Error updating array element: $e');
    }
  }
}
