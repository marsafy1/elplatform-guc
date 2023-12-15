import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';

class UserService {
  static final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  static Future<User> getUserById(String? id) async {
    if (id == null) throw Exception("id is null");
    return await _usersCollectionReference
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        return User(
            id: documentSnapshot.id,
            firstName: userData["first_name"],
            lastName: userData["last_name"],
            email: userData["email"],
            userType: (userData["user_type"] as String).toUserType(),
            isPublisher: userData["is_publisher"],
            header: userData["header"],
            bio: userData["bio"],
            faculty: userData["faculty"],
            gucId: userData["guc_id"]);
      } else {
        throw Exception("User not found");
      }
    });
  }
}
