import 'package:flutter_test/flutter_test.dart';

import 'package:tocaan_weather_task/my_app.dart';

void main() {
  testWidgets('App renders home page', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Weather'), findsOneWidget);
  });
}
