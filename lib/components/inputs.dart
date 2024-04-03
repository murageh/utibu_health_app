// rounded text field
import 'dart:math';

import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final String? helperText;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;

  const RoundedTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.validator,
    this.contentPadding,
    this.decoration,
    this.helperText,
    this.minLines,
    this.maxLines,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        minLines: minLines,
        maxLines: max(maxLines ?? 1, minLines ?? 1),
        decoration: decoration ??
            InputDecoration(
              hintText: hintText,
              helperText: helperText,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
      ),
    );
  }
}

// rounded DropdownButtonFormField
class RoundedDropdownButtonFormField<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final FormFieldSetter<T>? onChanged;
  final FormFieldValidator<T>? validator;

  const RoundedDropdownButtonFormField({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }
}

// subtly rounded ElevatedButton
class SubtlyRoundedElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  const SubtlyRoundedElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ?? ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: child,
    );
  }
}