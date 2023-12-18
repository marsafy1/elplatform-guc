import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils_functions/profile.dart';

class Comment extends StatelessWidget {
  final CommentModel comment;
  const Comment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    Widget userAvatar = generateAvatar(context, comment.user!);
    return ListTile(
      leading: userAvatar,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(comment.user!.firstName),
          Text(timeago.format(comment.dateCreated),
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
      subtitle: Text(comment.comment),
    );
  }
}
