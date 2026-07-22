import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Future<Dio> getDio() async {
    final dio = _dio;
    if (dio != null) return dio;

    const timeout = Duration(seconds: 30);
    final newDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
      ),
    );
    _dio = newDio;

    await _addDioHeaders(newDio);
    _addDioInterceptors(newDio);
    return newDio;
  }

  static Future<void> _addDioHeaders(Dio dio) async {
    dio.options.headers = {
      'Accept': 'application/json',
    };
  }

  static void _addDioInterceptors(Dio dio) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
