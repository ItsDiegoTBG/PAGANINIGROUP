import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paganini/core/utils/colors.dart';

class TextFormFieldSecondVersion extends StatelessWidget {
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final IconData? icon;
  final String hintext;
  final InputBorder? inputBorder;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;
  const TextFormFieldSecondVersion(
      {super.key,
      required this.controller,
      required this.textCapitalization,
      required this.icon,
      required this.hintext,
      this.inputBorder = InputBorder.none,
      this.textAlign = TextAlign.center,
      this.inputFormatters = const <TextInputFormatter>[],
      required this.onChanged,
      required this.validator,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      textAlign: textAlign ?? TextAlign.center,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
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
        hintText: hintext,
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
    );
  }
}
