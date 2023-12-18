import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';

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
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                // Perform the delete operation
                await onConfirm();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(confirmButton),
            ),
          ],
        );
      },
    );
  }

  static Future showPublishRequestDialog({
    required BuildContext context,
    required Function onConfirm,
    required String title,
  }) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                FormInputField(
                  name: "title",
                  icon: Icons.title,
                  controller: titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: messageController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Message',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                onConfirm(titleController.text, messageController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
