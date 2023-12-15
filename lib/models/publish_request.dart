import 'package:guc_swiss_knife/models/user.dart';

class PublishRequest {
  String id;
  String title;
  String content;
  String userId;
  DateTime createdAt = DateTime.now();
  bool approved;
  PublishRequest({
    this.id = "",
    required this.title,
    required this.content,
    required this.userId,
    required this.approved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'user_id': userId,
      'created_at': createdAt,
      'approved': approved,
    };
  }

  //from map
  PublishRequest.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        content = map['content'],
        userId = map['user_id'],
        createdAt = map['created_at'].toDate(),
        approved = map['approved'];
}
