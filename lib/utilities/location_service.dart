// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService extends ChangeNotifier {
  String _userLocation = 'Failed to fetch location data details';
  late double latitude;
  late double longitude;

  Future<String> getLocation() async {
    // IMP PERMISSION LINE
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } on PlatformException catch (e) {
      print('$e : occurred in LocationService.dart');
      return _userLocation;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return _userLocation;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> addresses = await GeocodingPlatform.instance
          .placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark first = addresses.first;

      String locality = first.locality ?? '';
      String subLocality = first.subLocality ?? '';

      _userLocation = '$subLocality, $locality.';
      notifyListeners();
      return _userLocation;
    } catch (e) {
      print('$e : occurred in LocationService.dart');
      return _userLocation;
    }
  }

  Future<double> getLat() async {
    // IMP PERMISSION LINE
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } on PlatformException catch (e) {
      print(e);
      return 19.109906;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return 19.109906;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position.latitude;
    } catch (e) {
      print(e);
      return 19.109906;
    }
  }

  Future<double> getLong() async {
    // IMP PERMISSION LINE
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } on PlatformException catch (e) {
      print(e);
      return 72.867671;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return 72.867671;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position.longitude;
    } catch (e) {
      print(e);
      return 72.867671;
    }
  }
}
