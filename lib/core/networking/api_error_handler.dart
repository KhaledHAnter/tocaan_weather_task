import 'package:dio/dio.dart';

import 'error_model.dart';

class ApiErrorHandler {
  static ErrorModel handle(dynamic error) {
    if (error is DioException) {
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
