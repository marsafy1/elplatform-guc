class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final String? topic;
  final String? type;
  final Map<String, dynamic>? info;

  NotificationModel({
    this.id = '',
    this.title,
    this.message,
    this.topic,
    this.type,
    this.info,
  });

  NotificationModel.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'],
        title = map['title'],
        message = map['message'],
        topic = map['topic'],
        type = map['type'],
        info = map['info'];
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'topic': topic,
      'type': type,
      'info': info,
    };
  }
}
