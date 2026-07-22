import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tocaan_weather_task/my_app.dart';

void main() {
  testWidgets('App renders home page', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
    // Not pumpAndSettle: the initial weather fetch (including location
    // detection, which never resolves without a platform channel mock in
    // tests) keeps a loading animation running indefinitely. A single pump
    // is enough to confirm the static search bar renders.
    await tester.pump();

    expect(find.text('Search'), findsOneWidget);
  });
}
