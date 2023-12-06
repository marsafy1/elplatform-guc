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
                  rating: (e['rating'] as int).toDouble(),
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
}
