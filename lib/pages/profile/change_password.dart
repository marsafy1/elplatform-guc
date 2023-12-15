import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/profile/form_input_field.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final AuthProvider _authProvider;
  late final Map<String, FormInputField> fields;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    fields = {
      "old_password": FormInputField(
        name: "Old Password",
        controller: TextEditingController(),
        isPassword: true,
      ),
      "new_password": FormInputField(
        name: "New Password",
        controller: TextEditingController(),
        isPassword: true,
      ),
      "new_password_confirmation": FormInputField(
        name: "Confirm New Password",
        controller: TextEditingController(),
        isPassword: true,
        validator: (value) {
          if (value != fields["new_password"]!.controller.text) {
            return "Passwords do not match";
          }
          return null;
        },
      ),
    };
    super.initState();
  }

  @override
  void dispose() {
    for (var element in fields.entries) {
      element.value.controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [_inputFieldsSection()],
          ),
        ),
      ),
    );
  }

  Widget _inputFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fields.values
            .toList()
            .expand((widget) => [widget, const SizedBox(height: 5)])
            .toList(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            changePasswordClicked();
          },
          child: const Text('Change password'),
        ),
      ],
    );
  }

  Future<void> changePasswordClicked() async {
    final String oldPassword = fields["old_password"]!.controller.text;
    final String newPassword = fields["new_password"]!.controller.text;

    await _authProvider.changePassword(
        oldPassword: oldPassword, newPassword: newPassword);
    Navigator.of(context).pop();
  }
}
