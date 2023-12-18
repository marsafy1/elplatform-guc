import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthProvider _authProvider;
  late final GlobalKey<FormState> _formKey;
  late final Map<String, FormInputField> fields;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _formKey = GlobalKey<FormState>();

    fields = {
      "email": FormInputField(
          name: "Email",
          controller: TextEditingController(),
          icon: Icons.email,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email is required';
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
                _forgotPasswordSection(),
                _registerSection(),
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
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _inputFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...fields.values
            .toList()
            .expand((widget) => [widget, const SizedBox(height: 10)])
            .toList(),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _loginPressed();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _forgotPasswordSection() {
    return TextButton(
      onPressed: () {
        _forgotPasswordPressed();
      },
      child: const Text(
        "Forgot password?",
      ),
    );
  }

  Widget _registerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            _registerPressed();
          },
          child: const Text("Register"),
        ),
      ],
    );
  }

  Future<void> _loginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _authProvider.signIn(
          email: fields["email"]!.controller.text,
          password: fields["password"]!.controller.text);
    } catch (e) {
      if (e is AuthException) {
        _showError(e.message);
      } else {
        print('Unexpected error: $e');
        _showError('An unexpected error occurred. Please try again later.');
      }
    }
  }

  void _forgotPasswordPressed() {
    // Implement forgot password logic here
  }

  void _registerPressed() {
    Navigator.of(context).pushNamed('/register');
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
