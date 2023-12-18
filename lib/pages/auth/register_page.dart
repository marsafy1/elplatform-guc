import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

const String emailRegex = r'^[a-zA-Z]+\.[a-zA-Z]+@(student\.)?guc\.edu\.eg$';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthProvider _authProvider;
  late final GlobalKey<FormState> _formKey;
  late final Map<String, FormInputField> fields;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _formKey = GlobalKey<FormState>();

    fields = {
      "first_name": FormInputField(
          name: "First Name",
          controller: TextEditingController(),
          icon: Icons.person,
          validator: (value) {
            if (value!.isEmpty) {
              return 'First name is required';
            }
            return null;
          }),
      "last_name": FormInputField(
          name: "Last Name",
          controller: TextEditingController(),
          icon: Icons.person,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Last name is required';
            }
            return null;
          }),
      "email": FormInputField(
          name: "Email",
          controller: TextEditingController(),
          icon: Icons.email,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email is required';
            } else if (!RegExp(emailRegex).hasMatch(value)) {
              return 'Email should be a valid GUC email';
            }
            return null;
          }),
      "password": FormInputField(
          name: "Password",
          controller: TextEditingController(),
          icon: Icons.password,
          isPassword: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password is required';
            } else if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          }),
      "confirm_password": FormInputField(
          name: "Confirm Password",
          controller: TextEditingController(),
          icon: Icons.password,
          isPassword: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Confirm password is required';
            } else if (value != fields["password"]!.controller.text) {
              return 'Passwords do not match';
            }

            return null;
          }),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _headerSection(),
                _inputFieldsSection(),
                _loginSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _headerSection() {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Create your account to get started"),
        SizedBox(height: 50),
      ],
    );
  }

  _inputFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...fields.values
            .toList()
            .expand((widget) => [widget, const SizedBox(height: 10)])
            .toList(),
        ElevatedButton(
          onPressed: () {
            _registerPressed();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          child: const Text(
            "Register",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _loginSection() {
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

  Future<void> _registerPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final UserType userType =
        fields["email"]!.controller.text.contains("student")
            ? UserType.student
            : UserType.instructor;
    try {
      await _authProvider.signUp(
          email: fields["email"]!.controller.text,
          password: fields["password"]!.controller.text,
          firstName: fields["first_name"]!.controller.text,
          lastName: fields["last_name"]!.controller.text,
          userType: userType);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (e is AuthException) {
        _showError(e.message);
      } else {
        print('Unexpected error: $e');
        _showError('An unexpected error occurred. Please try again later.');
      }
    }
  }

  void _loginPressed() {
    Navigator.of(context).pushNamed('/login');
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
