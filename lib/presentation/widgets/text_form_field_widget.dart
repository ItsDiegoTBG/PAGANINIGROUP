import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paganini/core/utils/colors.dart';


class TextFormFieldWidget extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      decoration:  InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor,width: 2)
        ),
          border: const UnderlineInputBorder(
            
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontWeight: FontWeight.w300)),
      keyboardType: textInputType,
      validator: validator,
    );
  }
}
