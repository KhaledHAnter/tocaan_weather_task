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
