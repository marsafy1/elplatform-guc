import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/course.dart';

class CourseService {
  final CollectionReference _coursesCollectionReference =
      FirebaseFirestore.instance.collection('courses');

  Future<List<Course>> getCourses() {
    return _coursesCollectionReference.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return Course(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          photoUrl: doc['photo_url'],
        );
      }).toList();
    });
  }
}
