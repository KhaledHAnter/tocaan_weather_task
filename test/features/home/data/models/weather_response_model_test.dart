import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocaan_weather_task/features/home/data/models/weather_response_model.dart';

const _sampleResponse = '''
{
    "location": {
        "name": "Cairo",
        "region": "Al Qahirah",
        "country": "Egypt",
        "lat": 30.05,
        "lon": 31.25,
        "tz_id": "Africa/Cairo",
        "localtime_epoch": 1784742950,
        "localtime": "2026-07-22 20:55"
    },
    "current": {
        "last_updated_epoch": 1784742300,
        "last_updated": "2026-07-22 20:45",
        "temp_c": 34.1,
        "temp_f": 93.4,
        "is_day": 0,
        "condition": {
            "text": "Clear",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
            "code": 1000
        },
        "wind_mph": 21.3,
        "wind_kph": 34.2,
        "wind_degree": 330,
        "wind_dir": "NNW",
        "pressure_mb": 1008.0,
        "pressure_in": 29.77,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 41,
        "cloud": 0,
        "feelslike_c": 38.3,
        "feelslike_f": 100.9,
        "windchill_c": 36.6,
        "windchill_f": 98.0,
        "heatindex_c": 35.5,
        "heatindex_f": 95.9,
        "dewpoint_c": 10.9,
        "dewpoint_f": 51.7,
        "vis_km": 10.0,
        "vis_miles": 6.0,
        "uv": 0.0,
        "gust_mph": 26.8,
        "gust_kph": 43.1,
        "will_it_rain": 0,
        "chance_of_rain": 0,
        "will_it_snow": 0,
        "chance_of_snow": 0
    }
}
''';

void main() {
  test('WeatherResponseModel parses the full API response', () {
    final json = jsonDecode(_sampleResponse) as Map<String, dynamic>;
    final model = WeatherResponseModel.fromJson(json);

    expect(model.location?.name, 'Cairo');
    expect(model.location?.region, 'Al Qahirah');
    expect(model.location?.country, 'Egypt');
    expect(model.location?.lat, 30.05);
    expect(model.location?.lon, 31.25);
    expect(model.location?.tzId, 'Africa/Cairo');
    expect(model.location?.localtimeEpoch, 1784742950);
    expect(model.location?.localtime, '2026-07-22 20:55');

    final current = model.current;
    expect(current?.tempC, 34.1);
    expect(current?.tempF, 93.4);
    expect(current?.isDay, false);
    expect(current?.condition?.text, 'Clear');
    expect(
      current?.condition?.icon,
      '//cdn.weatherapi.com/weather/64x64/night/113.png',
    );
    expect(current?.condition?.code, 1000);
    expect(current?.windKph, 34.2);
    expect(current?.windDir, 'NNW');
    expect(current?.humidity, 41);
    expect(current?.uv, 0.0);
    expect(current?.willItRain, false);
    expect(current?.willItSnow, false);
  });

  test('WeatherResponseModel round-trips through toJson', () {
    final json = jsonDecode(_sampleResponse) as Map<String, dynamic>;
    final model = WeatherResponseModel.fromJson(json);
    final roundTripped = WeatherResponseModel.fromJson(model.toJson());

    expect(roundTripped.location?.name, model.location?.name);
    expect(roundTripped.current?.tempC, model.current?.tempC);
    expect(roundTripped.current?.condition?.code, model.current?.condition?.code);
    expect(roundTripped.current?.isDay, model.current?.isDay);
  });
}
