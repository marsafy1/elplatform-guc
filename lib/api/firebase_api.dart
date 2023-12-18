import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guc_swiss_knife/main.dart';

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
    final fcmToken = await _firebaseMessaging.getToken();
    print("token: $fcmToken");
    await initPushNotifications();
  }

  void handleBackGroundMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/courses');
  }

  void handleForeGroundMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/courses');
  }

  Future<void> BackgroundHandler(RemoteMessage message) async {
    navigatorKey.currentState!.pushNamed('/courses');
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleBackGroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackGroundMessage);
    FirebaseMessaging.onBackgroundMessage(BackgroundHandler);
    FirebaseMessaging.onMessage.listen(handleForeGroundMessage);
  }
}
