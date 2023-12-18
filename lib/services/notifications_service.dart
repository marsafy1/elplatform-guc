import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final String collectionName = "notifications";
  static void sendLikeNotification(String likerId, String ownerId) async {
    //get liker first name
    DocumentSnapshot likerSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(likerId).get();
    //String likerFirstName = likerSnapshot.data()!['firstName'];
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'New Like',
      'body': 'Someone liked your post',
      'created_at': DateTime.now(),
    });
  }
}
