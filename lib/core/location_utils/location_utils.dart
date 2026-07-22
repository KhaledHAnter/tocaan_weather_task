import 'package:geolocator/geolocator.dart';

class LocationUtils {
  LocationUtils._();

  static Future<bool> getGPSStatus() async {
    return Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> getPermissionStatus() async {
    return Geolocator.requestPermission();
  }

  static bool isPermissionGranted(LocationPermission? status) {
    if (status == null) return false;
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  static Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Returns the user's current coordinates formatted as `"lat,lon"`,
  /// ready to be sent as the `q` query parameter to the weather API.
  ///
  /// Returns `null` if location services are disabled, permission was
  /// denied, or the position could not be determined.
  static Future<String?> getCurrentCoordinates() async {
    try {
      final isGpsEnabled = await getGPSStatus();
      if (!isGpsEnabled) return null;

      final permission = await getPermissionStatus();
      if (!isPermissionGranted(permission)) return null;

      final position = await getCurrentPosition();
      return '${position.latitude},${position.longitude}';
      // Any failure (permission race, platform error, timeout) should
      // fall back gracefully rather than crash the caller.
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }
}
