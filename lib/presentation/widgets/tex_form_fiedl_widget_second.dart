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
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        textAlign: textAlign ?? TextAlign.center,
        inputFormatters: inputFormatters,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIconColor: AppColors.primaryColor,
          prefixIcon: icon != null // Verifica si el icono es nulo
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon),
                )
              : null, //
          border: inputBorder,
          hintText: hintext,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ));
  }
}
