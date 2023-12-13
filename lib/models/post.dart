class Post {
  final String id;
  final String userId;
  final String category;
  final String title;
  final String description;
  final DateTime dateCreated;
  final List<dynamic>? photosUrls;

  Post({
    this.id = "",
    required this.title,
    required this.userId,
    required this.category,
    required this.description,
    required this.dateCreated,
    this.photosUrls,
  });

  factory Post.fromMap(Map<String, dynamic> map, String documentId) {
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
    };
  }
}
