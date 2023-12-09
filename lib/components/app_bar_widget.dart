import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(appName),
      backgroundColor: const Color.fromARGB(255, 9, 5, 5).withOpacity(0.3),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
