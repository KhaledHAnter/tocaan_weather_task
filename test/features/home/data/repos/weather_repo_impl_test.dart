// WeatherRepoImpl calls the static ApiService/DioFactory directly with no
// injection seam, so this test hits the real WeatherAPI endpoint. Tagged as
// an integration test (see dart_test.yaml) so it's excluded from the
// default `flutter test` run and doesn't require WEATHER_API_KEY or
// network access in CI. Run explicitly with:
//   flutter test -t integration --dart-define=WEATHER_API_KEY=your_key
@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:tocaan_weather_task/core/networking/api_result.dart';
import 'package:tocaan_weather_task/features/home/data/repos/weather_repo_impl.dart';

void main() {
  test(
    'WeatherRepoImpl.getCurrentWeather returns parsed weather for a real query',
    () async {
      final repo = WeatherRepoImpl();
      final result = await repo.getCurrentWeather(query: 'egypt');

      result.when(
        success: (weather) {
          expect(weather.location?.country, 'Egypt');
          expect(weather.current?.tempC, isNotNull);
          expect(weather.current?.condition?.text, isNotNull);
        },
        error: (apiError) {
          fail('Expected success but got error: ${apiError.message}');
        },
      );
    },
  );
}
