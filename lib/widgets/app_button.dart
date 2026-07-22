import 'package:flutter/material.dart';

import '../core/helpers/app_colors.dart';
import '../core/helpers/dimensions.dart';
import '../core/helpers/utils.dart';
import 'app_loading_indicator.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    super.key,
    this.color = AppColors.primary,
    this.titleColor = AppColors.white,
    this.onTap,
    this.onTapWhenDisabled,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.height,
    this.titleFontSize,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.titleFontWeight,
    this.radius = 14,
    this.isDisabled = false,
  });

  factory AppButton.outline({
    required String title,
    Color borderColor = AppColors.primary,
    Color titleColor = AppColors.primary,
    VoidCallback? onTap,
    bool isLoading = false,
    EdgeInsets? padding,
    double? height,
    Widget? leading,
    Widget? trailing,
    Color fillColor = AppColors.white,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    double radius = 14,
  }) {
    return _OutlineAppButton(
      title: title,
      onTap: onTap,
      color: borderColor,
      titleColor: titleColor,
      isLoading: isLoading,
      padding: padding,
      height: height,
      leading: leading,
      trailing: trailing,
      titleFontSize: titleFontSize,
      titleFontWeight: titleFontWeight,
      fillColor: fillColor,
      radius: radius,
    );
  }

  final String title;
  final Color color;
  final Color titleColor;
  final VoidCallback? onTap;
  final VoidCallback? onTapWhenDisabled;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double? height;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool isLoading;
  final bool isDisabled;
  final Widget? leading;
  final Widget? trailing;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return Padding(
      padding: margin,
      child: Stack(
        children: [
          InkWell(
            onTap: isLoading || isDisabled
                ? null
                : () {
                    onTap?.call();
                    Utils.dismissKeyboard();
                  },
            radius: radius,
            borderRadius: borderRadius,
            child: Container(
              height: height ?? 48,
              padding: padding ?? EdgeInsets.zero,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: color,
              ),
              child: isLoading
                  ? AppLoadingIndicator(
                      unconstrained: false,
                      size: 32,
                      padding: EdgeInsets.all(2.radius),
                      color: titleColor,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          SizedBox(width: 8.width),
                        ],
                        Flexible(
                          child: AppText(
                            title: title,
                            color: titleColor,
                            fontSize: titleFontSize,
                            fontWeight: titleFontWeight ?? FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (trailing != null) ...[
                          SizedBox(width: 8.width),
                          trailing!,
                        ],
                      ],
                    ),
            ),
          ),
          if (isDisabled || onTap == null)
            Positioned.fill(
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onTapWhenDisabled?.call,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutlineAppButton extends AppButton {
  const _OutlineAppButton({
    required super.title,
    required super.isLoading,
    required super.leading,
    required super.trailing,
    required this.fillColor,
    required super.titleFontSize,
    required super.titleFontWeight,
    required super.radius,
    super.onTap,
    super.color = AppColors.primary,
    super.titleColor = AppColors.secondary,
    super.padding,
    super.height,
  });

  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                onTap?.call();
                Utils.dismissKeyboard();
              },
        radius: radius,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height ?? 48,
          alignment: Alignment.center,
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: fillColor,
            border: Border.all(
              color: onTap == null ? AppColors.darkGray : color,
              width: 1.5,
            ),
          ),
          child: isLoading
              ? AppLoadingIndicator(
                  unconstrained: false,
                  size: 32,
                  padding: EdgeInsets.all(2.radius),
                  color: titleColor,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: AppText(
                        title: title,
                        textAlign: TextAlign.center,
                        color: onTap == null ? AppColors.black : titleColor,
                        fontSize: titleFontSize,
                        fontWeight: titleFontWeight ?? FontWeight.w600,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
