import 'package:flutter/material.dart';

import '../core/helpers/app_theme.dart';

enum WeatherIconKind {
  clear,
  partly,
  overcast,
  fog,
  drizzle,
  rain,
  snow,
  thunder,
}

/// Maps a WeatherAPI `condition.code` to one of the icon kinds drawn by
/// [WeatherConditionIcon]. See:
/// https://www.weatherapi.com/docs/weather_conditions.csv
WeatherIconKind weatherIconKindForCode(int? code) {
  switch (code) {
    case 1000:
      return WeatherIconKind.clear;
    case 1003:
      return WeatherIconKind.partly;
    case 1006:
    case 1009:
      return WeatherIconKind.overcast;
    case 1030:
    case 1135:
    case 1147:
      return WeatherIconKind.fog;
    case 1063:
    case 1072:
    case 1150:
    case 1153:
    case 1168:
    case 1171:
    case 1180:
    case 1183:
    case 1198:
    case 1201:
    case 1240:
      return WeatherIconKind.drizzle;
    case 1186:
    case 1189:
    case 1192:
    case 1195:
    case 1243:
    case 1246:
      return WeatherIconKind.rain;
    case 1066:
    case 1069:
    case 1114:
    case 1117:
    case 1204:
    case 1207:
    case 1210:
    case 1213:
    case 1216:
    case 1219:
    case 1222:
    case 1225:
    case 1237:
    case 1249:
    case 1252:
    case 1255:
    case 1258:
    case 1261:
    case 1264:
    case 1279:
    case 1282:
      return WeatherIconKind.snow;
    case 1087:
    case 1273:
    case 1276:
      return WeatherIconKind.thunder;
    default:
      return WeatherIconKind.overcast;
  }
}

Color _colorForKind(WeatherIconKind kind, Color mutedColor) {
  switch (kind) {
    case WeatherIconKind.clear:
      return const Color(0xFFF5A524);
    case WeatherIconKind.partly:
      return const Color(0xFFE0A94A);
    case WeatherIconKind.thunder:
      return const Color(0xFFF5A524);
    case WeatherIconKind.drizzle:
      return const Color(0xFF5B9BD5);
    case WeatherIconKind.rain:
      return const Color(0xFF4B8FD8);
    case WeatherIconKind.snow:
      return const Color(0xFF7FC0E0);
    case WeatherIconKind.overcast:
    case WeatherIconKind.fog:
      return mutedColor;
  }
}

class WeatherConditionIcon extends StatelessWidget {
  const WeatherConditionIcon({required this.kind, super.key, this.size = 40});

  final WeatherIconKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WeatherIconPainter(kind, context.colors.muted),
      ),
    );
  }
}

class _WeatherIconPainter extends CustomPainter {
  _WeatherIconPainter(this.kind, this.mutedColor);

  final WeatherIconKind kind;
  final Color mutedColor;

  static const double _viewBox = 24;
  static const Offset _cloudCenter = Offset(12, 12);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _viewBox;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = _colorForKind(kind, mutedColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (kind) {
      case WeatherIconKind.clear:
        _paintSun(canvas, paint);
      case WeatherIconKind.partly:
        _paintPartly(canvas, paint);
      case WeatherIconKind.overcast:
        _paintCloud(canvas, paint);
      case WeatherIconKind.fog:
        _paintFog(canvas, paint);
      case WeatherIconKind.drizzle:
        _paintDrizzle(canvas, paint);
      case WeatherIconKind.rain:
        _paintRain(canvas, paint);
      case WeatherIconKind.snow:
        _paintSnow(canvas, paint);
      case WeatherIconKind.thunder:
        _paintThunder(canvas, paint);
    }

    canvas.restore();
  }

  void _paintSun(Canvas canvas, Paint paint) {
    canvas.drawCircle(_cloudCenter, 4.4, paint);
    _line(canvas, paint, 12, 2.3, 12, 4.3);
    _line(canvas, paint, 12, 19.7, 12, 21.7);
    _line(canvas, paint, 2.3, 12, 4.3, 12);
    _line(canvas, paint, 19.7, 12, 21.7, 12);
    _line(canvas, paint, 5.2, 5.2, 6.6, 6.6);
    _line(canvas, paint, 17.4, 17.4, 18.8, 18.8);
    _line(canvas, paint, 5.2, 18.8, 6.6, 17.4);
    _line(canvas, paint, 17.4, 6.6, 18.8, 5.2);
  }

  void _paintPartly(Canvas canvas, Paint paint) {
    final sunPaint = Paint()
      ..color = const Color(0xFFF5A524)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(const Offset(8.5, 7.5), 2.9, sunPaint);
    _line(canvas, sunPaint, 8.5, 2.6, 8.5, 3.9);
    _line(canvas, sunPaint, 3.6, 7.5, 4.9, 7.5);
    _line(canvas, sunPaint, 5.1, 4.1, 6, 5);
    _line(canvas, sunPaint, 12, 3.6, 12.9, 4.5);
    canvas.drawPath(_cloudPath(), paint);
  }

  void _paintCloud(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
  }

  void _paintFog(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
    _line(canvas, paint, 5, 21, 13, 21);
    _line(canvas, paint, 15, 21, 19, 21);
  }

  void _paintDrizzle(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
    _line(canvas, paint, 8, 20, 7.3, 22);
    _line(canvas, paint, 12, 20, 11.3, 22);
    _line(canvas, paint, 16, 20, 15.3, 22);
  }

  void _paintRain(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
    _line(canvas, paint, 8, 20, 7, 22.6);
    _line(canvas, paint, 12, 20, 11, 22.6);
    _line(canvas, paint, 16, 20, 15, 22.6);
  }

  void _paintSnow(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
    final dot = Paint()
      ..color = _colorForKind(WeatherIconKind.snow, mutedColor);
    canvas.drawCircle(const Offset(8, 21), 0.55, dot);
    canvas.drawCircle(const Offset(12, 22), 0.55, dot);
    canvas.drawCircle(const Offset(16, 21), 0.55, dot);
  }

  void _paintThunder(Canvas canvas, Paint paint) {
    canvas.drawPath(_cloudPath(), paint);
    final bolt = Path()
      ..moveTo(13, 19)
      ..lineTo(10.5, 22)
      ..lineTo(12.5, 22)
      ..lineTo(11, 24.5);
    canvas.drawPath(bolt, paint);
  }

  /// Matches the design's cloud path:
  /// `M17.5 18h-11a4 4 0 0 1-.5-7.97A6 6 0 0 1 17.66 9 4.5 4.5 0 0 1 17.5 18z`
  Path _cloudPath() {
    final path = Path()..moveTo(17.5, 18);
    path.relativeLineTo(-11, 0);
    path.relativeArcToPoint(
      const Offset(-0.5, -7.97),
      radius: const Radius.circular(4),
    );
    path.relativeArcToPoint(
      const Offset(11.66, -1.03),
      radius: const Radius.circular(6),
    );
    path.relativeArcToPoint(
      const Offset(-0.16, 9),
      radius: const Radius.circular(4.5),
    );
    path.close();
    return path;
  }

  void _line(
    Canvas canvas,
    Paint paint,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(covariant _WeatherIconPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.mutedColor != mutedColor;
}
