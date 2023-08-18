// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:flutter_application_demo/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_demo/models/point.dart';
import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String? date;
  @HiveField(4)
  String? time;
  @HiveField(5)
  Place? place;
  @HiveField(6)
  double? initialDistance;
  @HiveField(7)
  bool isTracking;
  @HiveField(8)
  bool isArrived;
  @HiveField(9)
  bool? isDone;

  void toggleDone() {
    isDone = !isDone!;
  }

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.place,
    required this.initialDistance,
    required this.isTracking,
    required this.isArrived,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'place': place,
      'initialDistance': initialDistance,
      'isTracking': isTracking,
      'isArrived': isArrived,
    };
  }

  Reminder copy({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    Place? place,
    double? initialDistance,
    bool? isTracking,
    bool? isArrived,
  }) {
    return Reminder(
      id: title ?? this.id,
      title: title ?? this.title,
      description: title ?? this.description,
      date: title ?? this.date,
      time: title ?? this.time,
      place: place ?? this.place,
      initialDistance: initialDistance ?? this.initialDistance,
      isTracking: isTracking ?? this.isTracking,
      isArrived: isArrived ?? this.isArrived,
    );
  }

  @override
  String toString() {
    String reminderStr = '{';
    reminderStr = '$reminderStr\n  "id": "$id",';
    reminderStr = '$reminderStr\n  "title": "$title",';
    reminderStr = '$reminderStr\n  "title": "$description",';
    reminderStr = '$reminderStr\n  "title": "$date",';
    reminderStr = '$reminderStr\n  "title": "$time",';
    reminderStr = '$reminderStr\n  "place": $place,';
    reminderStr = '$reminderStr\n  "initialDistance": $initialDistance,';
    reminderStr = '$reminderStr\n  "isTracking": $isTracking,';
    reminderStr = '$reminderStr\n  "isArrived": $isArrived,';
    reminderStr = '$reminderStr\n}';
    return reminderStr;
  }

  double remainderDistance(Point current) {
    double inMeters = Geolocator.distanceBetween(current.latitude,
        current.longitude, place!.position.latitude, place!.position.longitude);
    return inMeters;
  }

  double bearing(Point current) {
    double inDegrees = Geolocator.bearingBetween(current.latitude,
        current.longitude, place!.position.latitude, place!.position.longitude);
    return inDegrees;
  }

  double traveledDistance(Point current) {
    double remainder = remainderDistance(current);
    if (initialDistance! < remainder) initialDistance = remainder;

    return (initialDistance! - remainder);
  }

  double? traveledDistancePercent(Point current) {
    double traveled = traveledDistance(current);
    if (initialDistance == 0.0) return 1;
    return (traveled / initialDistance!);
  }
}
