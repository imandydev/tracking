
import 'package:flutter/foundation.dart';
import 'package:flutter_apps/utils/convert_util.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../configurations/time_configuration.dart';

class GoogleMapService {

  late final LocationSettings locationSettings;

  static final GoogleMapService _googleMapService = GoogleMapService._internal();

  factory GoogleMapService() => _googleMapService;

  GoogleMapService._internal();


  isEnabledGetLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isEnabled) {
      return false;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      }
    }
    return false;
  }

  loadLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  getAddressDetails() async {
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    List<Placemark> places =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = places[0];

    StringBuffer result = StringBuffer();
    result.writeln(DateFormat(TimeConfiguration.dateTimeYYYYMMDDHHMMSS)
        .format(DateTime.now()));
    result.writeln("");
    result.writeln(
        "${place.country}, ${place.locality}, ${place.name}");
    result.writeln("");
    result.writeln(
        "${ConvertUtil.convertToLatitudeLongitudeFormat(position.latitude)} ${ConvertUtil.convertToLatitudeLongitudeFormat(position.longitude, isLongitude: true)}");

    return result.toString();
  }


}