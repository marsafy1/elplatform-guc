import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  const CategoryIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon,
      size: 18,
    );
  }
}
