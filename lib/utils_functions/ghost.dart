import 'package:flutter/material.dart';

Widget generateGhostAvatar() {
  Widget avatar;

  avatar = const CircleAvatar(
    backgroundColor: Colors.black,
    backgroundImage: AssetImage('assets/ghost.png'), // Use AssetImage directly
    radius: 20, // Set the radius to half of the SizedBox to fit perfectly
  );

  return SizedBox(height: 40, width: 40, child: avatar);
}
