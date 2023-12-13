import 'package:flutter/material.dart';

class VerifiedCheck extends StatelessWidget {
  const VerifiedCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary, // Blue background color
        shape: BoxShape.circle, // Circular shape
      ),
      child: const Icon(
        Icons.check, // Checkmark icon
        color: Colors.white, // White checkmark
        size:
            24 * 0.6, // Sizing the icon to be a bit smaller than the container
      ),
    );
  }
}
