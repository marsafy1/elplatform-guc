import './user.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String comment;
  final DateTime dateCreated;
  User? user;

  Comment(
      {this.id = "",
      required this.postId,
      required this.userId,
      required this.comment,
      required this.dateCreated,
      this.user});

  factory Comment.fromMap(Map<String, dynamic> map, String documentId,
      {User? user}) {
    return Comment(
        id: documentId,
        userId: map['userId'] ?? "Default",
        postId: map['postId'] ?? "Default",
        comment: map['comment'] ?? "Default Comment",
        dateCreated: map['dateCreated'] != null
            ? map['dateCreated'].toDate()
            : DateTime.now(),
        user: user);
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'comment': comment,
      'dateCreated': dateCreated,
    };
  }
}
