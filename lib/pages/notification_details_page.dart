import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Widget>;
    final Widget widget = routeArgs['widget']!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: SingleChildScrollView(child: widget),
    );
  }
}
