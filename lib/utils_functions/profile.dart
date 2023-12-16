import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';

Widget generateAvatar(BuildContext context, User user,
    {double? radius, bool? isClickable = true}) {
  String avatarChar = user.firstName.characters.first.toUpperCase();
  Widget avatar;

  if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
    avatar = CircleAvatar(
      backgroundColor: Colors.black,
      backgroundImage: NetworkImage(user.photoUrl!),
    );
  } else {
    var rand = Random();
    List<MaterialColor> avatarBg = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.orange,
    ];
    avatar = CircleAvatar(
      backgroundColor: avatarBg[rand.nextInt(avatarBg.length)],
      child: Text(
        avatarChar,
        style: TextStyle(fontSize: (radius ?? 35) / 2),
      ),
    );
  }

  avatar = GestureDetector(
      onTap: () {
        if (!isClickable!) return;
        Navigator.of(context).pushNamed('/profile', arguments: {
          'userId': user.id,
        });
      },
      child:
          SizedBox(height: radius ?? 40, width: radius ?? 40, child: avatar));

  return avatar;
}
