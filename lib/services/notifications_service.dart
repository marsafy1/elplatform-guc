import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

import '../models/notification.dart';

class NotificationService {
  final String collectionName = "notifications";
  static void sendLikeNotification(
      String likerId, String ownerId, String postId) async {
    User liker = await UserService.getUserById(likerId);
    Notification notification = Notification(
      'Like',
      '${liker.firstName} ${liker.lastName} liked your post',
      likerId,
      '/topics/$ownerId',
      'like',
      {'postId': postId},
    );
    await FirebaseFirestore.instance.collection('notifications').add(
          notification.toMap(),
        );
  }
}
