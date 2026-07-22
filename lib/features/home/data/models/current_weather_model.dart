import 'condition_model.dart';

class CurrentWeatherModel {
  CurrentWeatherModel({
    this.lastUpdatedEpoch,
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.visKm,
    this.visMiles,
    this.uv,
    this.gustMph,
    this.gustKph,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) =>
      CurrentWeatherModel(
        lastUpdatedEpoch: json['last_updated_epoch'] as int?,
        lastUpdated: json['last_updated'] as String?,
        tempC: (json['temp_c'] as num?)?.toDouble(),
        tempF: (json['temp_f'] as num?)?.toDouble(),
        isDay: json['is_day'] == 1,
        condition: json['condition'] == null
            ? null
            : ConditionModel.fromJson(
                json['condition'] as Map<String, dynamic>,
              ),
        windMph: (json['wind_mph'] as num?)?.toDouble(),
        windKph: (json['wind_kph'] as num?)?.toDouble(),
        windDegree: json['wind_degree'] as int?,
        windDir: json['wind_dir'] as String?,
        pressureMb: (json['pressure_mb'] as num?)?.toDouble(),
        pressureIn: (json['pressure_in'] as num?)?.toDouble(),
        precipMm: (json['precip_mm'] as num?)?.toDouble(),
        precipIn: (json['precip_in'] as num?)?.toDouble(),
        humidity: json['humidity'] as int?,
        cloud: json['cloud'] as int?,
        feelslikeC: (json['feelslike_c'] as num?)?.toDouble(),
        feelslikeF: (json['feelslike_f'] as num?)?.toDouble(),
        windchillC: (json['windchill_c'] as num?)?.toDouble(),
        windchillF: (json['windchill_f'] as num?)?.toDouble(),
        heatindexC: (json['heatindex_c'] as num?)?.toDouble(),
        heatindexF: (json['heatindex_f'] as num?)?.toDouble(),
        dewpointC: (json['dewpoint_c'] as num?)?.toDouble(),
        dewpointF: (json['dewpoint_f'] as num?)?.toDouble(),
        visKm: (json['vis_km'] as num?)?.toDouble(),
        visMiles: (json['vis_miles'] as num?)?.toDouble(),
        uv: (json['uv'] as num?)?.toDouble(),
        gustMph: (json['gust_mph'] as num?)?.toDouble(),
        gustKph: (json['gust_kph'] as num?)?.toDouble(),
        willItRain: json['will_it_rain'] == 1,
        chanceOfRain: json['chance_of_rain'] as int?,
        willItSnow: json['will_it_snow'] == 1,
        chanceOfSnow: json['chance_of_snow'] as int?,
      );

  final int? lastUpdatedEpoch;
  final String? lastUpdated;
  final double? tempC;
  final double? tempF;
  final bool? isDay;
  final ConditionModel? condition;
  final double? windMph;
  final double? windKph;
  final int? windDegree;
  final String? windDir;
  final double? pressureMb;
  final double? pressureIn;
  final double? precipMm;
  final double? precipIn;
  final int? humidity;
  final int? cloud;
  final double? feelslikeC;
  final double? feelslikeF;
  final double? windchillC;
  final double? windchillF;
  final double? heatindexC;
  final double? heatindexF;
  final double? dewpointC;
  final double? dewpointF;
  final double? visKm;
  final double? visMiles;
  final double? uv;
  final double? gustMph;
  final double? gustKph;
  final bool? willItRain;
  final int? chanceOfRain;
  final bool? willItSnow;
  final int? chanceOfSnow;

  Map<String, dynamic> toJson() => {
    'last_updated_epoch': lastUpdatedEpoch,
    'last_updated': lastUpdated,
    'temp_c': tempC,
    'temp_f': tempF,
    'is_day': (isDay ?? false) ? 1 : 0,
    'condition': condition?.toJson(),
    'wind_mph': windMph,
    'wind_kph': windKph,
    'wind_degree': windDegree,
    'wind_dir': windDir,
    'pressure_mb': pressureMb,
    'pressure_in': pressureIn,
    'precip_mm': precipMm,
    'precip_in': precipIn,
    'humidity': humidity,
    'cloud': cloud,
    'feelslike_c': feelslikeC,
    'feelslike_f': feelslikeF,
    'windchill_c': windchillC,
    'windchill_f': windchillF,
    'heatindex_c': heatindexC,
    'heatindex_f': heatindexF,
    'dewpoint_c': dewpointC,
    'dewpoint_f': dewpointF,
    'vis_km': visKm,
    'vis_miles': visMiles,
    'uv': uv,
    'gust_mph': gustMph,
    'gust_kph': gustKph,
    'will_it_rain': (willItRain ?? false) ? 1 : 0,
    'chance_of_rain': chanceOfRain,
    'will_it_snow': (willItSnow ?? false) ? 1 : 0,
    'chance_of_snow': chanceOfSnow,
  };
}
