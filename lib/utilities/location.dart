// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import '../models/reminder_db.dart';
import 'package:flutter_application_demo/models/place.dart';
import 'package:flutter_application_demo/models/point.dart';
import 'package:provider/provider.dart';

import '../views/LocationReminder.dart';

Future<bool> _checkPermissions() async {
  bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (isServiceEnabled == false) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    return Future.error('Location services permission is denied');
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location services permission is permanently denied');
  }
  return true;
}

void handlePositionUpdates(BuildContext context) {
  final appStates = Provider.of<ReminderDB>(context, listen: false);

  late LocationSettings locationSettings;

  if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      // forceLocationManager: true,
      intervalDuration: const Duration(seconds: 10),
      // Foreground notification config to keep the app alive when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "Avis app will continue running in background",
        notificationTitle: "Avis app - Running",
        enableWakeLock: true,
        notificationIcon:
            AndroidResource(name: 'reminder', defType: 'drawable'),
      ),
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.best,
      activityType: ActivityType.fitness,
      distanceFilter: 0,
      pauseLocationUpdatesAutomatically: true,
      // Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  } else {
    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
  }

  positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (value) async {
            final currentPosition = Point(
              latitude: value.latitude,
              longitude: value.longitude,
            );
            appStates.setCurrent(currentPosition);

            final reminders = appStates.reminderAll();
            LocationView loc = LocationView();
            for (int i = 0; i < reminders.length; ++i) {
              if (reminders[i].isTracking == true) {
                final remainderDistance =
                    reminders[i].remainderDistance(appStates.getCurrent());
                final radius = reminders[i].place!.radius;
                if (remainderDistance <= radius!) {
                  appStates.reminderUpdate(reminders[i].copy(isArrived: true));
                } else {
                  appStates.reminderUpdate(reminders[i].copy(isArrived: false));
                }
              }
            }
            if (appStates.notify == true) {
              if (appStates.arrivalAll().isNotEmpty) {
                if (appStates.reminderAll().isEmpty) {
                  FlutterRingtonePlayer.stop();
                  appStates.setRinging(false);
                } else {
                  if (appStates.ringing == false) {
                    loc.scheduleNotificationBasedOnLocation();
                    FlutterRingtonePlayer.playAlarm(
                      asAlarm: true,
                      looping: true,
                      volume: 1.0,
                    );
                    appStates.setRinging(true);
                  }
                }
              } else {
                if (appStates.ringing == true) {
                  FlutterRingtonePlayer.stop();
                  appStates.setRinging(false);
                }
              }
            }
          },
          cancelOnError: true,
          onError: (error, stackTrace) {
            appStates.setListening(false);
            debugPrint(error.toString());
            debugPrint(stackTrace.toString());
          });
}

String? pointValidate(String? value,
    {String? message = 'Not a number', double limit = 1.0}) {
  if (value == null || value == '') {
    return message;
  } else {
    final validNumber = double.tryParse(value);
    if (validNumber == null || validNumber > limit || validNumber < -limit) {
      return message;
    }
  }
  return null;
}

Future<Place> getCurrentLocation() async {
  await _checkPermissions().onError(
    (error, stackTrace) => Future.error(error!, stackTrace),
  );

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
    // forceAndroidLocationManager: true,
    timeLimit: const Duration(seconds: 20),
  );

  final point = Point(
    latitude: position.latitude,
    longitude: position.longitude,
  );

  return Place(position: point);
}
