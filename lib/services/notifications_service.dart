import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

class NotificationService {
  final String collectionName = "notifications";
  static void sendLikeNotification(
      String likerId, String ownerId, String postId) async {
    //get liker first name
    User liker = await UserService.getUserById(likerId);

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'Like',
      'senderId': likerId,
      'receiverId': '/topics/$ownerId',
      'message': '${liker.firstName} ${liker.lastName} liked your post',
      'type': 'like',
      'info': {
        'postId': postId,
      },
    });
  }
}
