import 'package:dio/dio.dart';

import 'error_model.dart';

class ApiErrorHandler {
  /// Converts any thrown error into a single [ErrorModel] so callers never
  /// need to know whether the failure was a network issue, a timeout, or a
  /// well-formed error response from the API.
  static ErrorModel handle(dynamic error) {
    if (error is DioException) {
      // Each DioExceptionType maps to a distinct, user-facing message so
      // "no internet" and "server took too long" don't look identical.
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ErrorModel(message: 'Connection to server failed');
        case DioExceptionType.cancel:
          return ErrorModel(message: 'Request to server was cancelled');
        case DioExceptionType.connectionTimeout:
          return ErrorModel(message: 'Connection timeout with server');
        case DioExceptionType.receiveTimeout:
          return ErrorModel(
            message: 'Receive timeout in connection with server',
          );
        case DioExceptionType.sendTimeout:
          return ErrorModel(message: 'Send timeout in connection with server');
        case DioExceptionType.transformTimeout:
          return ErrorModel(message: 'Timeout transforming server response');
        case DioExceptionType.badCertificate:
          return ErrorModel(message: 'Invalid server certificate');
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        case DioExceptionType.unknown:
          return ErrorModel(
            message: 'Connection to server failed due to internet connection',
          );
      }
    } else {
      return ErrorModel(message: 'Unknown error occurred');
    }
  }
}

// WeatherAPI nests its error payload one level deep, e.g.
// `{"error": {"code": 1006, "message": "No matching location found."}}`,
// which does not match ErrorModel's own {message, code, data} shape. Unwrap
// the "error" key first so invalid-city and other API errors surface their
// real message instead of falling through to a generic one.
ErrorModel _handleError(dynamic data) {
  if (data is Map<String, dynamic>) {
    final error = data['error'];
    if (error is Map<String, dynamic>) {
      return ErrorModel.fromJson(error);
    }
    return ErrorModel.fromJson(data);
  }
  return ErrorModel(message: 'Something went wrong');
}
