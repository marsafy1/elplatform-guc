import 'package:guc_swiss_knife/models/user.dart';

class PublishRequest {
  String title;
  String content;
  List<String> tags;
  User? user;
  DateTime createdAt = DateTime.now();
  PublishRequest(
      {required this.title,
      required this.content,
      required this.tags,
      this.user});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
    };
  }

  factory PublishRequest.fromJson(Map<String, dynamic> json) {
    return PublishRequest(
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
    );
  }
}
