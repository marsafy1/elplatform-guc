import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

import '../models/notification_model.dart';

class NotificationService {
  static final Map<String, String> _collectionsToNotifications = {
    'feed': 'post',
    'confessions': 'confession',
    'questions': 'question',
    "lost_and_founds": 'lost and found post',
  };
  static void sendLikeNotification(
      String likerId, String postId, String collection, String ownerId) async {
    User liker = await UserService.getUserById(likerId);
    String action =
        ['feed', 'confessions'].contains(collection) ? "liked" : "upvoted";
    NotificationModel notification = NotificationModel(
      title: 'Like',
      message:
          '${liker.firstName} ${liker.lastName} $action your ${_collectionsToNotifications[collection]}',
      topic: '/topics/$ownerId',
      type: 'like',
      info: {'postId': postId, 'collection': collection},
    );

    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }

  static void sendCommentNotification(String commenterId, String postId,
      String collection, String ownerId) async {
    User commenter = await UserService.getUserById(commenterId);
    String action = collection != "questions" ? "commented on" : "answered";
    NotificationModel notification = NotificationModel(
      title: 'Comment',
      message:
          '${commenter.firstName} ${commenter.lastName} $action your ${_collectionsToNotifications[collection]}',
      topic: '/topics/$ownerId',
      type: 'Comment',
      info: {'postId': postId, 'collection': collection},
    );
    print(notification.toMap());
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }

  Stream<List<NotificationModel>> fetchNotifications(String userId) {
    Stream<List<NotificationModel>> fetchedNotifications = FirebaseFirestore
        .instance
        .collection("notifications")
        .where('topic', isEqualTo: '/topics/$userId')
        .snapshots()
        .asyncMap((snapshot) async {
      List<NotificationModel> notifications = [];
      for (var doc in snapshot.docs) {
        NotificationModel notification =
            NotificationModel.fromMap(doc.data(), doc.id);
        notifications.add(notification);
      }
      return notifications;
    });
    return fetchedNotifications;
  }
}
