import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
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
          return ErrorModel(
            message: LocaleKeys.error_connection_failed.tr(),
            isConnectionError: true,
          );
        case DioExceptionType.cancel:
          return ErrorModel(message: LocaleKeys.error_request_cancelled.tr());
        case DioExceptionType.connectionTimeout:
          return ErrorModel(
            message: LocaleKeys.error_connection_timeout.tr(),
            isConnectionError: true,
          );
        case DioExceptionType.receiveTimeout:
          return ErrorModel(
            message: LocaleKeys.error_receive_timeout.tr(),
            isConnectionError: true,
          );
        case DioExceptionType.sendTimeout:
          return ErrorModel(
            message: LocaleKeys.error_send_timeout.tr(),
            isConnectionError: true,
          );
        case DioExceptionType.transformTimeout:
          return ErrorModel(message: LocaleKeys.error_transform_timeout.tr());
        case DioExceptionType.badCertificate:
          return ErrorModel(message: LocaleKeys.error_bad_certificate.tr());
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        case DioExceptionType.unknown:
          return ErrorModel(
            message: LocaleKeys.error_no_internet.tr(),
            isConnectionError: true,
          );
      }
    } else {
      return ErrorModel(message: LocaleKeys.error_unknown.tr());
    }
  }
}

// WeatherAPI nests its error payload one level deep, e.g.
// `{"error": {"code": 1006, "message": "No matching location found."}}`,
// which does not match ErrorModel's own {message, code, data} shape. Unwrap
// the "error" key first so invalid-city and other API errors surface their
// real message instead of falling through to a generic one. Note: that
// message comes from WeatherAPI itself (always in English) — it is not
// ours to localize, unlike the fallback below.
ErrorModel _handleError(dynamic data) {
  if (data is Map<String, dynamic>) {
    final error = data['error'];
    if (error is Map<String, dynamic>) {
      return ErrorModel.fromJson(error);
    }
    return ErrorModel.fromJson(data);
  }
  return ErrorModel(message: LocaleKeys.error_something_went_wrong.tr());
}
