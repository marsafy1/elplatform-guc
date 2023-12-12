import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final String inputPlaceholder;
  final int minLines;
  final int maxLines;
  const TextFieldInput({
    super.key,
    required this.inputPlaceholder,
    required this.controller,
    required this.minLines,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: inputPlaceholder,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid input';
        }
        return null;
      },
    );
  }
}
