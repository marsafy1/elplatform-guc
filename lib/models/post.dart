import './user.dart';

class Post {
  final String id;
  final String userId;
  final String category;
  final String title;
  final String description;
  final DateTime dateCreated;
  final bool anon;
  final bool resolved;
  final List<dynamic>? photosUrls;
  final List<String>? likedByUsers; // New field to track likes
  User? user;

  Post(
      {this.id = "",
      required this.title,
      required this.userId,
      required this.category,
      required this.description,
      required this.dateCreated,
      required this.anon,
      required this.resolved,
      this.photosUrls,
      this.user,
      this.likedByUsers});

  factory Post.fromMap(Map<String, dynamic> map, String documentId,
      {User? user}) {
    List<String>? likedByUsers;
    if (map['likedByUsers'] != null) {
      likedByUsers = List<String>.from(map['likedByUsers'] as List<dynamic>);
    }

    return Post(
      id: documentId,
      title: map['title'] ?? "Title",
      userId: map['userId'] ?? "Default",
      resolved: map['resolved'] ?? false,
      anon: map['anon'] ?? false,
      category: map['category'] ?? "all",
      description: map['description'] ?? "Description",
      photosUrls: map['photosUrls'] ?? [],
      dateCreated: map['dateCreated'] != null
          ? map['dateCreated'].toDate()
          : DateTime.now(),
      user: user,
      likedByUsers: likedByUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'resolved': resolved,
      'anon': anon,
      'category': category,
      'description': description,
      'photosUrls': photosUrls,
      'dateCreated': dateCreated,
      'likedByUsers': likedByUsers,
    };
  }
}
