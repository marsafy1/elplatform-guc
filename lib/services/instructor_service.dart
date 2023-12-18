import 'package:cloud_firestore/cloud_firestore.dart';
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
}
