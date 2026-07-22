import '../../../../core/networking/api_result.dart';
import '../models/weather_response_model.dart';

abstract class WeatherRepo {
  Future<ApiResult<WeatherResponseModel>> getCurrentWeather({
    required String query,
  });
}
