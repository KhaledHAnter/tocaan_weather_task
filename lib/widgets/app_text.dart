import 'package:flutter/material.dart';

import '../core/helpers/app_colors.dart';
import '../core/helpers/dimensions.dart';
import '../core/helpers/utils.dart';

enum AppFontFamily {
  arabic(id: 'Tajawal'),
  english(id: 'Poppins');

  const AppFontFamily({required this.id});

  final String id;
}

enum StringLanguage { arabic, english, mixed, empty }

class AppText extends StatelessWidget {
  const AppText({
    required this.title,
    super.key,
    this.color = AppColors.black,
    this.fontSize,
    this.textAlign,
    this.decoration,
    this.overflow,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.height,
    this.fontFamily,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.textDirection,
    this.decorationThickness,
    this.autoDetectFontFamily = true,
    this.normalizeHeight = true,
  });

  final String title;
  final FontWeight fontWeight;
  final Color color;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final double? decorationThickness;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final AppFontFamily? fontFamily;
  final EdgeInsetsGeometry padding;
  final void Function()? onTap;
  final bool autoDetectFontFamily;
  final bool normalizeHeight;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final resolvedFontSize = fontSize ?? 14.font;
    final resolvedFontFamily =
        fontFamily ??
        _detectFontFamily(title, enabled: autoDetectFontFamily) ??
        (Utils.isAR ? AppFontFamily.arabic : AppFontFamily.english);
    final lineHeightMultiplier = _resolveLineHeightMultiplier(
      fontSize: resolvedFontSize,
      explicitHeight: height,
      normalizeHeight: normalizeHeight,
    );
    final strutStyle = lineHeightMultiplier == null
        ? StrutStyle.disabled
        : StrutStyle(
            fontFamily: resolvedFontFamily.id,
            fontSize: resolvedFontSize,
            height: lineHeightMultiplier,
            fontWeight: fontWeight,
            forceStrutHeight: true,
            leading: 0,
            leadingDistribution: TextLeadingDistribution.even,
          );

    final text = Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      textScaler: TextScaler.noScaling,
      strutStyle: strutStyle,
      style: TextStyle(
        color: color,
        fontSize: resolvedFontSize,
        height: lineHeightMultiplier,
        decoration: decoration ?? TextDecoration.none,
        decorationThickness: decorationThickness,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: color,
        fontWeight: fontWeight,
        fontFamily: resolvedFontFamily.id,
      ),
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
    );

    if (onTap == null && padding == EdgeInsets.zero) {
      return text;
    }

    return Padding(
      padding: padding,
      child: onTap == null ? text : InkWell(onTap: onTap, child: text),
    );
  }
}

StringLanguage _detectLanguage(String text) {
  final cleaned = text.trim();
  if (cleaned.isEmpty) return StringLanguage.empty;

  final arabicRegex = RegExp('[؀-ۿ]');
  final englishRegex = RegExp('[a-zA-Z]');

  final hasArabic = arabicRegex.hasMatch(cleaned);
  final hasEnglish = englishRegex.hasMatch(cleaned);

  if (hasArabic && hasEnglish) return StringLanguage.mixed;
  if (hasArabic) return StringLanguage.arabic;
  if (hasEnglish) return StringLanguage.english;
  return StringLanguage.empty;
}

AppFontFamily? _detectFontFamily(String text, {bool enabled = true}) {
  if (!enabled) return null;
  final isAppArabic = Utils.isAR;
  final textLang = _detectLanguage(text);
  final isTextArabic = textLang == StringLanguage.arabic;
  final isTextMixed = textLang == StringLanguage.mixed;

  if (isAppArabic) {
    return (!isTextArabic && !isTextMixed)
        ? AppFontFamily.english
        : AppFontFamily.arabic;
  } else {
    return isTextArabic ? AppFontFamily.arabic : AppFontFamily.english;
  }
}

/// Shared line-height tuning for Poppins and Tajawal.
const double _lineHeight = 1.25;

double? _resolveLineHeightMultiplier({
  required double fontSize,
  required double? explicitHeight,
  required bool normalizeHeight,
}) {
  if (explicitHeight != null) {
    return explicitHeight / fontSize;
  }
  if (!normalizeHeight) {
    return null;
  }
  return _lineHeight;
}
