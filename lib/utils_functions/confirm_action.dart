import 'package:flutter/material.dart';

class ConfirmAction {
  static void showConfirmationDialog({
    required BuildContext context,
    required Function onConfirm,
    required String title,
    required String message,
    required String confirmButton,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete operation
                onConfirm();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(confirmButton),
            ),
          ],
        );
      },
    );
  }
}
