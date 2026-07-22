class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1/';
  static const String currentWeather = 'current.json';

  // Supplied at build/run time, e.g.:
  //   flutter run --dart-define=WEATHER_API_KEY=your_key_here
  // Never hardcode a real key here — this file is committed to source
  // control. Get a free key at https://www.weatherapi.com/.
  static const String apiKey = String.fromEnvironment('WEATHER_API_KEY');
}
