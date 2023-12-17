import './user.dart';

class Post {
  final String id;
  final String userId;
  final String category;
  final String title;
  final String description;
  final DateTime dateCreated;
  final List<dynamic>? photosUrls;
  final Set<String> likedByUsers; // New field to track likes
  User? user;

  Post(
      {this.id = "",
      required this.title,
      required this.userId,
      required this.category,
      required this.description,
      required this.dateCreated,
      this.photosUrls,
      this.user,
      this.likedByUsers = const {} // Default to empty set
      });

  factory Post.fromMap(Map<String, dynamic> map, String documentId,
      {User? user}) {
    return Post(
      id: documentId,
      title: map['title'] ?? "Title",
      userId: map['userId'] ?? "Default",
      category: map['category'] ?? "all",
      description: map['description'] ?? "Description",
      photosUrls: map['photosUrls'] ?? [],
      dateCreated: map['dateCreated'] != null
          ? map['dateCreated'].toDate()
          : DateTime.now(),
      user: user,
      likedByUsers:
          Set<String>.from(map['likedByUsers'] ?? []), // Extract likes
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'category': category,
      'description': description,
      'photosUrls': photosUrls,
      'dateCreated': dateCreated,
      'likedByUsers': likedByUsers.toList(), // Convert to list for storage
    };
  }
}
