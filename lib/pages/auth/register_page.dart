import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthProvider _authProvider;

  final Map<String, DynamicField> fields = {
    "first_name": DynamicField(
        name: "First Name",
        controller: TextEditingController(),
        icon: Icons.person),
    "last_name": DynamicField(
        name: "Last Name",
        controller: TextEditingController(),
        icon: Icons.person),
    "email": DynamicField(
        name: "Email", controller: TextEditingController(), icon: Icons.email),
    "password": DynamicField(
        name: "Password",
        controller: TextEditingController(),
        icon: Icons.password,
        isPassword: true),
    "confirm_password": DynamicField(
        name: "Confirm Password",
        controller: TextEditingController(),
        icon: Icons.password,
        isPassword: true),
  };

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
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
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(),
            _inputFields(),
            _login(),
          ],
        ),
      ),
    );
  }

  _header() {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Create your account to get started"),
      ],
    );
  }

  _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...fields.entries
            .map((entry) {
              return _inputField(
                  name: entry.value.name,
                  inputController: entry.value.controller,
                  icon: entry.value.icon,
                  isPassword: entry.value.isPassword);
            })
            .expand((widget) => [widget, const SizedBox(height: 10)])
            .toList(),
        ElevatedButton(
          onPressed: () {
            _registerPressed();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text(
            "Register",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _inputField(
      {required name,
      required inputController,
      required icon,
      isPassword = false}) {
    return TextField(
      controller: inputController,
      decoration: InputDecoration(
        hintText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: isPassword,
    );
  }

  Future<void> _registerPressed() async {
    // todo: handle password mismatch and empty fields
    try {
      await _authProvider.signUp(
          email: fields["email"]!.controller.text,
          password: fields["password"]!.controller.text,
          firstName: fields["first_name"]!.controller.text,
          lastName: fields["last_name"]!.controller.text);
    } catch (e) {
      if (e is AuthException) {
        _showError(e.message);
      } else {
        print('Unexpected error: $e');
        _showError('An unexpected error occurred. Please try again later.');
      }
    }
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _login() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextButton(
          onPressed: () {
            _loginPressed();
          },
          child: const Text("Login"),
        ),
      ],
    );
  }

  void _loginPressed() {
    Navigator.of(context).pushNamed('/login');
  }
}

class DynamicField {
  final String name;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;

  DynamicField({
    required this.name,
    required this.controller,
    required this.icon,
    this.isPassword = false,
  });
}
