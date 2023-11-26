class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final String faculty;
  final bool isPublisher;
  final String photoUrl;
  final String? gucId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
    required this.faculty,
    required this.isPublisher,
    required this.photoUrl,
    this.gucId,
  });
}
