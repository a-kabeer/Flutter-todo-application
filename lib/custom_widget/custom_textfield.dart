import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.prefixIcon,
  });


  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
