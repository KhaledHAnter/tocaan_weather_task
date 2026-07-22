import 'current_weather_model.dart';
import 'location_model.dart';

class WeatherResponseModel {
  WeatherResponseModel({this.location, this.current});

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) =>
      WeatherResponseModel(
        location: json['location'] == null
            ? null
            : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
        current: json['current'] == null
            ? null
            : CurrentWeatherModel.fromJson(
                json['current'] as Map<String, dynamic>,
              ),
      );

  final LocationModel? location;
  final CurrentWeatherModel? current;

  Map<String, dynamic> toJson() => {
    'location': location?.toJson(),
    'current': current?.toJson(),
  };
}
