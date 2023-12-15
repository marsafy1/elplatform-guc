import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? hintText;
  final bool? enabled;
  final bool? multiline;

  const FormInputField(
      {super.key,
      required this.name,
      required this.controller,
      this.isPassword,
      this.validator,
      this.maxLength,
      this.hintText,
      this.enabled = true,
      this.multiline = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: name, hintText: hintText),
      maxLength: maxLength,
      validator: validator ?? (value) => null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      maxLines: multiline! ? null : 1,
      keyboardType: multiline! ? TextInputType.multiline : TextInputType.text,
    );
  }
}
