import 'package:cloud_firestore/cloud_firestore.dart';
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
  static final Map<String, Function> _handlers = {
    'like': handlePostInteraction,
    'comment': handlePostInteraction,
  };

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
    String type = message.data['type']!;
    _handlers[type]!(message);
  }

  static void handlePostInteraction(RemoteMessage? message) async {
    if (message == null) return;
    String postId = json.decode(message.data['info']!)['postId'];
    String collection = json.decode(message.data['info']!)['collection'];
    DocumentSnapshot snapshot =
        await PostsService().getPostById(postId, collection);
    User poster = await UserService.getUserById(snapshot['userId']);
    Post post = Post.fromMap(snapshot as Map<String, dynamic>, snapshot.id,
        user: poster);
    navigatorKey.currentState!.pushNamed('/notificationDetails',
        arguments: {'widget': PostWidget(post: post, collection: collection)});
  }

  void handleForeGroundMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/courses');
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    String type = message.data['type']!;
    _handlers[type]!(message);
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
