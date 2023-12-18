import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guc_swiss_knife/components/posts/post.dart';
import 'package:guc_swiss_knife/main.dart';
import 'package:guc_swiss_knife/models/post.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/posts_service.dart';
import 'dart:convert';

import 'package:guc_swiss_knife/services/user_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await initPushNotifications();
  }

  void handleBackGroundMessage(RemoteMessage? message) async {
    if (message == null) return;
    String postId = json.decode(message.data['info']!)['postId'];
    Post post = await PostsService().getPostById(postId);
    User poster = await UserService.getUserById(post.userId);
    post.user = poster;
    navigatorKey.currentState!.pushNamed('/notificationDetails',
        arguments: {'widget': PostWidget(post: post, collection: "feed")});
  }

  void handleForeGroundMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/courses');
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    navigatorKey.currentState!.pushNamed('/courses');
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleBackGroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackGroundMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen(handleForeGroundMessage);
  }
}
