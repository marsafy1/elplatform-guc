enum UserType { student, instructor, admin }

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserType userType;
  final bool isPublisher;
  final String? header;
  final String? bio;
  final String? faculty;
  final String? photoUrl;
  final String? gucId;
  final bool? isPending;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.isPublisher,
    this.header,
    this.bio,
    this.faculty,
    this.photoUrl,
    this.gucId,
    this.isPending = false,
  });
  static User get defaultUser => User(
        id: 'default_id',
        firstName: 'Default',
        lastName: 'User',
        email: 'default@example.com',
        userType: UserType.student, // Default user type
        isPublisher: false,
        // Provide default values for all other properties
        header: 'Default header',
        bio: 'Default bio',
        faculty: 'Default faculty',
        photoUrl: null,
        gucId: 'default_gucid',
        isPending: false,
      );
  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    return User(
      id: documentId,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      userType: (map['user_type'] as String? ?? '').toUserType(),
      isPublisher: map['is_publisher'] as bool? ?? false,
      header: map['header'] as String?,
      bio: map['bio'] as String?,
      faculty: map['faculty'] as String?,
      photoUrl: map['photo_url'] as String?,
      gucId: map['guc_id'] as String?,
      isPending: map['is_pending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_type': userType.toShortString(),
      'is_publisher': isPublisher,
      'header': header,
      'bio': bio,
      'faculty': faculty,
      'photo_url': photoUrl,
      'guc_id': gucId,
      'is_pending': isPending,
    };
  }
}

// Extensions for UserType conversion
extension ParseToString on UserType {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension ParseToUserType on String {
  UserType toUserType() {
    return UserType.values.firstWhere(
      (e) => e.toShortString().toLowerCase() == toLowerCase(),
      orElse: () => UserType.student,
    );
  }
}
