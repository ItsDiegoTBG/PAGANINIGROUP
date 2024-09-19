import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final String? hintText;
  const TextFieldForm({
    super.key,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return  TextField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: hintText ?? "",
      ),
    );
  }
}