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
            gucId: userData["guc_id"],
            photoUrl: userData["photo_url"]);
      } else {
        throw Exception("User not found");
      }
    });
  }

  static Future<void> createUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required UserType userType,
    required bool isPublisher,
  }) async {
    await _usersCollectionReference.doc(id).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'is_publisher': isPublisher,
      'user_type': userType.toShortString(),
    });
  }

  static Future<void> updateUser({
    required String id,
    String? firstName,
    String? lastName,
    String? header,
    String? bio,
    String? faculty,
    String? gucId,
    String? profilePictureUrl,
    bool? isPending,
  }) async {
    await _usersCollectionReference.doc(id).update({
      'first_name': firstName,
      'last_name': lastName,
      'header': header,
      'bio': bio,
      'faculty': faculty,
      'guc_id': gucId,
      'photo_url': profilePictureUrl,
      'is_pending': isPending,
    });
  }
}
