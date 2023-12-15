import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/comment.dart';
import '../../utils_functions/profile.dart';

class Comment extends StatelessWidget {
  final CommentModel comment;
  const Comment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    Widget userAvatar = generateAvatar(comment.user!);
    return ListTile(
      leading: userAvatar,
      title: Text(comment.user!.firstName),
      subtitle: Text(comment.comment),
    );
  }
}
