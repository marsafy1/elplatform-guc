import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Toast {
  static void show(
    BuildContext context,
    String message,
    String type, {
    IconData icon = FontAwesomeIcons.info,
    VoidCallback? onTap,
  }) {
    Map<String, Color> typeToColor = {
      "success": Colors.green,
      "error": Colors.red,
      "warning": Colors.orange,
      "info": Colors.blue
    };

    Color backgroundColor = typeToColor[type] ?? Colors.grey;
    backgroundColor = backgroundColor.withOpacity(0.7);

    final overlay = Overlay.of(context);

    // Declare the overlayEntry variable
    OverlayEntry? overlayEntry;

    // Initialize the overlayEntry
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 100.0,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
            // Dismiss the toast when tapped
            if (overlayEntry!.mounted) {
              overlayEntry!.remove();
            }
          },
          child: Center(
            child: Material(
              color: backgroundColor,
              elevation: 10.0,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(76, 255, 255, 255),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: FaIcon(
                        icon,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      message,
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5)).then((value) {
      if (overlayEntry?.mounted ?? false) {
        overlayEntry?.remove();
      }
    });
  }
}
