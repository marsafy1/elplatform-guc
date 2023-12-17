import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    RouteObserverService().logUserActivity('/notifications');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Notifications Page");
  }
}
