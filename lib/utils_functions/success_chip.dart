import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget statusChip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
    margin: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        if (text.isNotEmpty) const FaIcon(FontAwesomeIcons.check, size: 10),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}
