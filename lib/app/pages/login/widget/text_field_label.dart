import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class TextFieldWithLabel extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final bool obsecureText;
  final String hintText, label;
  const TextFieldWithLabel({
    super.key,
    this.suffix,
    required this.label,
    this.controller,
    this.textInputAction,
    this.obsecureText = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        ),
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          obscureText: obsecureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textTheme.bodyMedium,
            suffixIcon: suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusDeffault),
              borderSide: const BorderSide(
                color: kBorderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusDeffault),
              borderSide: const BorderSide(
                color: kBorderColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusDeffault),
              borderSide: const BorderSide(
                color: kButtonColor,
                width: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
