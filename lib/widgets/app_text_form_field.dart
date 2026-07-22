import 'package:flutter/material.dart';

import '../core/helpers/app_theme.dart';
import '../core/helpers/utils.dart';
import 'app_text.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.hint,
    this.controller,
    this.textInputAction = TextInputAction.search,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final String? hint;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final void Function(String v)? onFieldSubmitted;
  final void Function(String v)? onChanged;

  double get _radius => 16;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colors.border;
    final fillColor = context.colors.surface;
    final hintColor = context.colors.muted;
    return TextField(
      controller: controller,
      cursorColor: context.colors.onSurface,
      onTapOutside: (_) => Utils.dismissKeyboard(),

      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,
      style: TextStyle(
        fontFamily: Utils.isAR
            ? AppFontFamily.arabic.id
            : AppFontFamily.english.id,
      ),
      decoration: InputDecoration(
        hintText: hint ?? '',
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        border: _border(borderColor),
        enabledBorder: _border(borderColor),
        focusedBorder: _border(borderColor),
      ),
    );
  }

  InputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
