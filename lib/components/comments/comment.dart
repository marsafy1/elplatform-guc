import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../utils_functions/profile.dart';

class Comment extends StatelessWidget {
  final User user;
  final String comment;
  const Comment({super.key, required this.user, required this.comment});

  @override
  Widget build(BuildContext context) {
    Widget userAvatar = generateAvatar(context, user);
    return ListTile(
      leading: userAvatar,
      title: Text(user.firstName),
      subtitle: Text(comment),
    );
  }
}
