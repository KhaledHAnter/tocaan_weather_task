import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import 'app_colors.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.border,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  final Color background;
  final Color surface;
  final Color onSurface;
  final Color muted;
  final Color border;
  final Color skeletonBase;
  final Color skeletonHighlight;

  static const light = AppThemeColors(
    background: AppColors.lightBg,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    muted: AppColors.lightMuted,
    border: AppColors.lightBorder,
    skeletonBase: AppColors.lightSkeletonBase,
    skeletonHighlight: AppColors.lightSkeletonHighlight,
  );

  static const dark = AppThemeColors(
    background: AppColors.darkBg,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    muted: AppColors.darkMuted,
    border: AppColors.darkBorder,
    skeletonBase: AppColors.darkSkeletonBase,
    skeletonHighlight: AppColors.darkSkeletonHighlight,
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? muted,
    Color? border,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
    );
  }
}

extension BuildContextThemeX on BuildContext {
  AppThemeColors get colors => Theme.of(this).extension<AppThemeColors>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _base(
    brightness: Brightness.light,
    colors: AppThemeColors.light,
  );

  static ThemeData get dark =>
      _base(brightness: Brightness.dark, colors: AppThemeColors.dark);

  static ThemeData _base({
    required Brightness brightness,
    required AppThemeColors colors,
  }) {
    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      fontFamily: AppFontFamily.english.id,
      scaffoldBackgroundColor: colors.background,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      extensions: [colors],
    );
  }
}
