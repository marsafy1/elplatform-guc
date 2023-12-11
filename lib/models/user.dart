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
  });
}

enum UserType { student, instructor, admin }

extension ParseToString on UserType {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension ParseToUserType on String {
  UserType toUserType() {
    return UserType.values.firstWhere(
      (element) => element.toShortString() == this,
      orElse: () => UserType.student,
    );
  }
}
