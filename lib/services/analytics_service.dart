import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:guc_swiss_knife/models/user.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  static Future<void> setUserProperties(
      {required String userId, required UserType userType}) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(
        name: 'user_type', value: userType.toShortString());
  }

  static Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  static Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  static Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  static Future<void> logViewOthersProfile() async {
    await _analytics.logEvent(name: 'view_others_profile');
  }
}
