import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Toast {
  static void show(BuildContext context, String message, String type,
      {IconData icon = FontAwesomeIcons.info, VoidCallback? onTap}) {
    Map<String, Color> typeToColor = {
      "success": Colors.green,
      "error": Colors.red,
      "warning": Colors.yellow,
      "info": Colors.blue
    };

    Color backgroundColor = typeToColor[type] ?? Colors.grey;
    backgroundColor = backgroundColor.withOpacity(0.7);

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top +
            100.0, // Positioning it below the status bar
        width:
            MediaQuery.of(context).size.width, // Match the width of the screen
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap(); // Execute the callback function if provided
            }
            // Dismiss the toast when tapped
            // if (overlayEntry.mounted) {
            //   overlayEntry.remove();
            // }
          },
          child: Center(
            child: Material(
              color: backgroundColor,
              elevation:
                  10.0, // Optional: gives the Material widget some shadow.
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
                        shape: BoxShape.circle, // Makes the container circular
                        color:
                            Color.fromARGB(76, 255, 255, 255), // Circle color
                      ),
                      padding: const EdgeInsets.all(
                          10), // The padding inside the circle
                      child: FaIcon(
                        icon,
                        size: 14, // Adjust icon size as needed
                        color: Colors.white, // Icon color
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

    // Automatically dismiss the notification after some duration
    Future.delayed(const Duration(seconds: 5)).then((value) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
