import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:paganini/core/utils/colors.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormattersForm;
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.textInputType,
    this.enabled = true,
    this.inputFormattersForm
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      inputFormatters: inputFormattersForm ?? [],
      decoration: InputDecoration(
         
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Borde circular
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Borde circular
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 18, // Tamaño de texto del hint
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16, // Espaciado vertical
          horizontal: 20, // Espaciado horizontal
        ),
      ),
      style: const TextStyle(
        fontSize: 18, // Tamaño del texto ingresado
        height: 1.5, // Espaciado entre líneas
      ),
      keyboardType: textInputType,
      validator: validator,
    );
  }
}
