import 'package:dio/dio.dart';

import 'dio_factory.dart';

export 'package:dio/dio.dart';

class ApiService {
  ApiService._();

  static Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final dio = await DioFactory.getDio();
    return dio.get<dynamic>(
      path,
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
  }) async {
    final dio = await DioFactory.getDio();
    return dio.post<dynamic>(
      path,
      data: formData ?? data,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
  }) async {
    final dio = await DioFactory.getDio();
    return dio.patch<dynamic>(
      path,
      data: formData ?? data,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
  }) async {
    final dio = await DioFactory.getDio();
    return dio.put<dynamic>(
      path,
      data: formData ?? data,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
  }) async {
    final dio = await DioFactory.getDio();
    return dio.delete<dynamic>(
      path,
      data: formData ?? data,
      options: Options(headers: headers),
    );
  }
}
