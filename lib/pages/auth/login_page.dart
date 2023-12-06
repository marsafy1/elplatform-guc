import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthProvider _authProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            _forgotPassword(),
            _register(),
          ],
        ),
      ),
    );
  }

  _header() {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _inputField(
            name: "Email",
            inputController: _emailController,
            icon: Icons.person),
        const SizedBox(height: 10),
        _inputField(
            name: "Password",
            inputController: _passwordController,
            icon: Icons.password,
            isPassword: true),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _loginPressed();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text(
            "Login",
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

  Future<void> _loginPressed() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    // todo: handle empty fields

    try {
      await _authProvider.signIn(email: email, password: password);
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

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        _forgotPasswordPressed();
      },
      child: const Text(
        "Forgot password?",
      ),
    );
  }

  void _forgotPasswordPressed() {
    // Implement forgot password logic here
  }

  Widget _register() {
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

  void _registerPressed() {
    Navigator.of(context).pushNamed('/register');
  }
}
