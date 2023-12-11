import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';

class UserService {
  static final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  static Future<User> getUserById(String? id) {
    if (id == null) throw Exception("id is null");
    return _usersCollectionReference.doc(id).get().then((doc) {
      return User(
        id: doc.id,
        firstName: doc['first_name'],
        lastName: doc['last_name'],
        photoUrl: doc['photo_url'],
        email: doc['email'],
        bio: doc['bio'],
        faculty: doc['faculty'],
        isPublisher: doc['is_publisher'],
        gucId: doc['guc_id'],
        userType: doc['user_type'] as UserType,
      );
    });
  }
}
