import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/notification_card.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/models/notification_model.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/notifications_service.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  NotificationService notificationService = NotificationService();
  late String? userId;

  @override
  void initState() {
    setState(() {
      userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    });
    RouteObserverService().logUserActivity('/notifications');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notificationService.fetchNotifications(userId ?? ""),
      builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? const NoContent(text: "No Data Available")
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      notification: snapshot.data![index],
                    );
                  },
                );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


