import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/weather_response_model.dart';
import 'weather_repo.dart';

/// Talks to WeatherAPI's `current.json` endpoint and normalizes both
/// success and failure into an [ApiResult] so callers (the cubit) never
/// deal with exceptions directly.
class WeatherRepoImpl implements WeatherRepo {
  @override
  Future<ApiResult<WeatherResponseModel>> getCurrentWeather({
    required String query,
  }) async {
    try {
      final response = await ApiService.get(
        ApiConstants.currentWeather,
        queryParams: {
          'key': ApiConstants.apiKey,
          'q': query,
        },
      );

      final weather = WeatherResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return ApiResult.success(weather);
      // Deliberately broad: ApiErrorHandler.handle already discriminates
      // DioException from other error types (e.g. a bad JSON cast above).
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      return ApiResult.error(ApiErrorHandler.handle(error));
    }
  }
}
