import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/helpers/app_colors.dart';
import '../core/helpers/dimensions.dart';
import '../core/helpers/utils.dart';
import 'app_text.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    this.hint,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.onTap,
    this.trailing,
    this.leading,
    this.label,
    this.requiredText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.borderColor = AppColors.textFieldBorderColor,
    this.fillColor = Colors.transparent,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.secure = false,
    this.hintColor,
    this.focusNode,
    this.inputFormatters,
    this.inputTextColor,
    this.readOnly = false,
    this.autofocus = false,
    this.labelFontSize,
    this.labelFontWeight,
    this.requiredTextColor = const Color(0xffB1B0AE),
    this.contentPadding,
    this.onLongPress,
    this.helperText,
  });

  final String? hint;
  final String? Function(String? v)? validator;
  final void Function(String v)? onChanged;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final Widget? leading;
  final String? label;
  final String? requiredText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Color borderColor;
  final Color? fillColor;
  final Color? inputTextColor;
  final bool secure;
  final void Function(String? v)? onSaved;
  final void Function(String? v)? onFieldSubmitted;
  final TextEditingController? controller;
  final Color? hintColor;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool autofocus;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final Color requiredTextColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? helperText;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool secure = false;

  @override
  void initState() {
    secure = widget.secure;
    super.initState();
  }

  double get _radius => 16;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller?.text,
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (field) {
        final hasError = field.hasError;
        final borderColor = hasError ? AppColors.red : widget.borderColor;
        final fieldFillColor = hasError
            ? AppColors.redCard.withValues(alpha: 0.3)
            : widget.fillColor ?? Colors.transparent;
        final textColor = hasError
            ? AppColors.red
            : widget.inputTextColor ?? AppColors.black;
        final iconColor = hasError ? AppColors.red : AppColors.gray;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.height),
                child: widget.requiredText == null
                    ? AppText(
                        title: widget.label!,
                        color: hasError ? AppColors.red : AppColors.black,
                        fontWeight: widget.labelFontWeight ?? FontWeight.w400,
                        fontSize: widget.labelFontSize ?? 12.font,
                      )
                    : Row(
                        children: [
                          AppText(
                            title: '${widget.label!} ',
                            color: hasError ? AppColors.red : AppColors.black,
                            fontWeight:
                                widget.labelFontWeight ?? FontWeight.w400,
                            fontSize: widget.labelFontSize ?? 12.font,
                          ),
                          AppText(
                            title: widget.requiredText!,
                            color: widget.requiredTextColor,
                            fontSize: 12.font,
                          ),
                        ],
                      ),
              ),
            InkWell(
              radius: _radius,
              onLongPress: widget.onLongPress != null
                  ? () {
                      Utils.dismissKeyboard();
                      widget.onLongPress!();
                    }
                  : null,
              onTap: widget.onTap != null
                  ? () {
                      Utils.dismissKeyboard();
                      widget.onTap!();
                    }
                  : null,
              borderRadius: BorderRadius.circular(_radius),
              child: AbsorbPointer(
                absorbing: widget.onTap != null,
                child: TextField(
                  autofocus: widget.autofocus,
                  readOnly: widget.readOnly,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  cursorColor: AppColors.primary,
                  cursorHeight: 20,
                  onChanged: (value) {
                    if (field.hasError) {
                      field.reset();
                    }
                    field.didChange(value);
                    widget.onChanged?.call(value);
                  },
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.inputType,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  onSubmitted: widget.onFieldSubmitted,
                  obscureText: secure,
                  obscuringCharacter: '*',
                  style: TextStyle(
                    color: textColor,
                    fontFamily: Utils.isAR ? 'Tajawal' : 'Poppins',
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: widget.hint ?? '',
                    fillColor: fieldFillColor,
                    filled: true,
                    errorText: field.errorText,
                    errorStyle: TextStyle(
                      color: AppColors.red,
                      fontSize: 10.font,
                      fontFamily: Utils.isAR ? 'Tajawal' : 'Poppins',
                      height: 1.2,
                    ),
                    hintStyle: TextStyle(
                      color: widget.hintColor ?? AppColors.grey30,
                      fontFamily: Utils.isAR ? 'Tajawal' : 'Poppins',
                      fontSize: 14,
                    ),
                    suffixIcon: UnconstrainedBox(
                      child: Builder(
                        builder: (context) {
                          if (widget.secure) {
                            return InkWell(
                              onTap: () => setState(() => secure = !secure),
                              child: FaIcon(
                                secure
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                color: iconColor,
                                size: 18,
                              ),
                            );
                          } else if (widget.trailing != null) {
                            return _withErrorTint(
                              widget.trailing!,
                              hasError: hasError,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    prefixIcon: widget.leading != null
                        ? _withErrorTint(widget.leading!, hasError: hasError)
                        : null,
                    contentPadding:
                        widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                    border: _border(borderColor),
                    enabledBorder: _border(borderColor),
                    focusedBorder: _border(
                      hasError ? AppColors.red : AppColors.primary,
                    ),
                    errorBorder: _border(AppColors.red),
                    focusedErrorBorder: _border(AppColors.red),
                  ),
                ),
              ),
            ),
            if (!hasError && widget.helperText != null) ...[
              SizedBox(height: 8.height),
              AppText(
                title: widget.helperText!,
                color: AppColors.grayText,
                fontSize: 10.font,
              ),
            ],
          ],
        );
      },
    );
  }

  InputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _withErrorTint(Widget child, {required bool hasError}) {
    if (!hasError) return child;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
      child: child,
    );
  }
}
