import 'package:flutter/material.dart';

import '../route_utils/route_utils.dart';

class Utils {
  static bool get isAR {
    final context = RouteUtils.context;
    if (context == null) return false;
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static void dismissKeyboard() {
    final context = RouteUtils.context;
    if (context == null) return;
    FocusScope.of(context).unfocus();
  }
}
