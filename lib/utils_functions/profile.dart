import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';

Widget generateAvatar(BuildContext context, User user) {
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
    avatar = GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/profile', arguments: {
          'userId': user.id,
        });
      },
      child: CircleAvatar(
        backgroundColor: avatarBg[rand.nextInt(avatarBg.length)],
        child: Text(avatarChar),
      ),
    );
  }

  return avatar;
}
