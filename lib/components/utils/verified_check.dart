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
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 24 * 0.6,
      ),
    );
  }
}
