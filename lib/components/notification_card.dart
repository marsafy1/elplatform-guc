import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/api/firebase_api.dart';
import 'package:guc_swiss_knife/components/posts/post.dart';
import 'package:guc_swiss_knife/main.dart';
import 'package:guc_swiss_knife/models/notification_model.dart';
import 'package:guc_swiss_knife/models/post.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/posts_service.dart';
import 'package:guc_swiss_knife/services/user_service.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();

  static Future<void> notificationCardOnTab(
      NotificationModel notification) async {
    String postId = notification.info!['postId'];
    String collection = notification.info!['collection'];
    DocumentSnapshot snapshot =
        await PostsService().getPostById(postId, collection);
    User poster = await UserService.getUserById(snapshot['userId']);
    Post post = Post.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.id,
        user: poster);
    navigatorKey.currentState!.pushNamed('/notificationDetails',
        arguments: {'widget': PostWidget(post: post, collection: collection)});
  }
}

class _NotificationCardState extends State<NotificationCard> {
  User? user;
  @override
  void initState() {
    UserService.getUserById(widget.notification.info!['senderId'])
        .then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: generateAvatar(context, user ?? User.defaultUser),
        trailing: Text(
          getFormattedDateTime(
              (widget.notification.info?['dateCreated'] as Timestamp?)
                      ?.toDate() ??
                  DateTime.now()),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 7),
        ),
        title: Text(widget.notification.title ?? ""),
        subtitle: Text(
          widget.notification.message ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          NotificationCard.notificationCardOnTab(widget.notification);
        },
      ),
    );
  }

  String getFormattedDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return '$formattedDate \n $formattedTime';
  }
}
