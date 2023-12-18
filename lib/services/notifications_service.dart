import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

import '../models/notification_model.dart';

class NotificationService {
  final String collectionName = "notifications";
  static void sendLikeNotification(
      String likerId, String postId, String collection, String ownerId) async {
    User liker = await UserService.getUserById(likerId);
    NotificationModel notification = NotificationModel(
      'Like',
      '${liker.firstName} ${liker.lastName} liked your $collection',
      '/topics/$ownerId',
      'like',
      {'postId': postId, 'collection': collection},
    );
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }

  static void sendCommentNotification(String commenterId, String postId,
      String collection, String ownerId) async {
    User commenter = await UserService.getUserById(commenterId);
    NotificationModel notification = NotificationModel(
      'Comment',
      '${commenter.firstName} ${commenter.lastName} commented on your $collection',
      '/topics/$postId',
      'comment',
      {'postId': postId, 'collection': collection},
    );
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }
}
