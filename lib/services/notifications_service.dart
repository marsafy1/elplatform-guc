import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
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
      info: {
        'postId': postId,
        'collection': collection,
        'senderId': likerId,
        'dateCreated': Timestamp.now(),
        'isRead': false,
      },
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
      type: 'comment',
      info: {
        'postId': postId,
        'collection': collection,
        'senderId': commenterId,
        'dateCreated': Timestamp.now(),
        'isRead': false,
      },
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
    return fetchedNotifications.map((notifications) {
      notifications.sort((a, b) {
        return ((b.info?['dateCreated'] as Timestamp?) ?? Timestamp.now())
            .compareTo(
                (a.info?['dateCreated'] as Timestamp?) ?? Timestamp.now());
      });
      return notifications;
    });
  }

  static void sendPublishRequestNotification(
      PublishRequest publishRequest) async {
    User requestOwner = await UserService.getUserById(publishRequest.userId);
    NotificationModel notification = NotificationModel(
        title: 'Publish Request',
        message:
            '${requestOwner.firstName} ${requestOwner.lastName} requested to be a publisher',
        topic: '/topics/admin',
        type: 'Comment',
        info: {
          'dateCreated': Timestamp.now(),
        });
    print(notification.toMap());
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }

  static void sendPublishRequestResponseNotification(
      PublishRequest publishRequest) async {
    User requestOwner = await UserService.getUserById(publishRequest.userId);
    NotificationModel notification = NotificationModel(
        title: 'Publish Request',
        message:
            '${requestOwner.firstName} ${requestOwner.lastName} requested to be a publisher',
        topic: '/topics/admin',
        type: 'Comment',
        info: {
          'dateCreated': Timestamp.now(),
        });
    print(notification.toMap());
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }

  static void readNotification(
      String notificationId, Map<String, dynamic> info) async {
    print(notificationId);
    info['isRead'] = true;
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'info': info});
  }
}
