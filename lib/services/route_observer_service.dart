import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteObserverService extends RouteObserver<PageRoute<dynamic>> {
  static final RouteObserverService _instance =
      RouteObserverService._internal();
  final CollectionReference _userActivityCollection =
      FirebaseFirestore.instance.collection('user_activity');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Session details
  String? _currentSessionId;
  DateTime? _sessionStartTime;

  factory RouteObserverService() => _instance;

  RouteObserverService._internal();

  Future<void> _startNewSession() async {
    final user = _auth.currentUser;
    if (user != null) {
      _currentSessionId = _userActivityCollection.doc().id;
      _sessionStartTime = DateTime.now();
      await _userActivityCollection.doc(_currentSessionId).set({
        'user_id': user.uid,
        'session_start_time': _sessionStartTime,
      });
    }
  }

  Future<void> logUserActivity(String routeName) async {
    // Start a new session if it hasn't been started yet
    if (_currentSessionId == null) {
      await _startNewSession();
    }

    final user = _auth.currentUser;
    if (user != null && _currentSessionId != null) {
      await _userActivityCollection
          .doc(_currentSessionId!)
          .collection('activities')
          .add({
        'route_name': routeName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      final routeName = route.settings.name;
      logUserActivity(routeName ?? 'Unknown');
    }
    super.didPush(route, previousRoute);
  }
}
