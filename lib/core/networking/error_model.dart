class ErrorModel {
  ErrorModel({
    this.message,
    this.code,
    this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    message: json['message'] as String?,
    code: json['code'] as int?,
    errors: json['data'] as Map<String, dynamic>?,
  );

  final String? message;
  final int? code;
  final Map<String, dynamic>? errors;

  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'data': errors,
  };

  /// Returns a string with all error messages.
  String getAllErrorMessages() {
    final errors = this.errors;
    if (errors == null || errors.isEmpty) {
      return message ?? 'Unknown error occurred';
    }

    return errors.entries
        .map((entry) => (entry.value as List).join(', '))
        .join('\n');
  }
}
