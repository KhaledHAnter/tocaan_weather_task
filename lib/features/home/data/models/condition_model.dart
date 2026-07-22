class ConditionModel {
  ConditionModel({this.text, this.icon, this.code});

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      ConditionModel(
        text: json['text'] as String?,
        icon: json['icon'] as String?,
        code: json['code'] as int?,
      );

  final String? text;
  final String? icon;
  final int? code;

  Map<String, dynamic> toJson() => {
    'text': text,
    'icon': icon,
    'code': code,
  };
}
