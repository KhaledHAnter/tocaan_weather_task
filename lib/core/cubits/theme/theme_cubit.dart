import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/shared_pref_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    unawaited(_loadThemeMode());
  }

  static ThemeCubit of(BuildContext context) => BlocProvider.of(context);

  Future<void> _loadThemeMode() async {
    final savedMode = await SharedPrefHelper.getString(
      SharedPrefHelper.themeModeKey,
    );
    emit(_themeModeFromString(savedMode));
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    await SharedPrefHelper.setString(
      SharedPrefHelper.themeModeKey,
      newMode.name,
    );
  }

  ThemeMode _themeModeFromString(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
