class Notification {
  final String title;
  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  final Map<String, dynamic> info;

  Notification(this.title, this.message, this.senderId, this.receiverId,
      this.type, this.info);

  Notification.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        message = map['message'],
        senderId = map['senderId'],
        receiverId = map['receiverId'],
        type = map['type'],
        info = map['info'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'info': info,
    };
  }
}
