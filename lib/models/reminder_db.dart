// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_demo/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/models/point.dart';
import 'check_if_user_logged_in.dart';
import 'reminder.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

late StreamSubscription<Position> positionStream;

// Hive boxes
late Box boxReminders;
late Box boxFavorites;
late Box boxPreferences;

class ReminderDB extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  CheckIfUserLoggedIn checkIfUserLoggedIn = CheckIfUserLoggedIn();

  late Point _currentPosition;

  bool ringing = false;
  bool listening = false;
  bool notify = true;

  final List<Reminder> _reminderList = [
    // Reminder(
    //   title: 'Reminder Title',
    //   description: 'Reminder description',
    //   date: 'Today',
    //   time: '17:00 pm',
    //   userLocation: 'Andheri East',
    // ),
  ];

  UnmodifiableListView<Reminder> get reminderList {
    return UnmodifiableListView(_reminderList);
  }

  void addReminder(
    String title,
    String description,
    String date,
    String time,
  ) {
    final reminder = Reminder(
      id: const Uuid().v4(),
      title: title,
      description: description,
      date: date,
      time: time,
      place: null,
      initialDistance: null,
      isTracking: false,
      isArrived: false,
    );

    //Add reminder to reminder local db
    _reminderList.add(reminder);

    //Add reminder to reminder remote db only if user is logged in
    if (checkIfUserLoggedIn.getCurrentUser()) {
      _firestore.collection('reminders').add({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'user': checkIfUserLoggedIn.getCurrentUserEmail(),
      });
    }

    // retrieving user specific reminders
    // if (checkIfUserLoggedIn.getCurrentUserEmail() != null) {
    //   _reminderList.add(reminder);
    //   _firestore.collection('reminders').add({
    //     'title': title,
    //     'description': description,
    //     'date': date,
    //     'time': time,
    //   });
    // }

    notifyListeners();
  }

  void addReminderBasedOnLocation(
    String title,
    String description,
    Place place,
    double initialDistance,
    bool isTracking,
    bool isArrived,
  ) {
    final reminder = Reminder(
      id: const Uuid().v4(),
      title: title,
      description: description,
      date: null,
      time: null,
      place: place,
      initialDistance: initialDistance,
      isTracking: true,
      isArrived: false,
    );

    //Add reminder to reminder local db
    _reminderList.add(reminder);

    //Add reminder to reminder remote db only if user is logged in
    if (checkIfUserLoggedIn.getCurrentUser()) {
      _firestore.collection('locationBasedReminders').add({
        'title': title,
        'description': description,
        'place': place,
        'initialDistance': initialDistance,
        'user': checkIfUserLoggedIn.getCurrentUserEmail(),
      });
    }

    notifyListeners();
  }

  void reminderUpdate(Reminder reminder) {
    final index =
        _reminderList.indexWhere((element) => element.id == reminder.id);
    if (index == -1) return;
    _reminderList[index] = reminder;
    notifyListeners();
  }

  void deleteReminder(Reminder reminder) {
    _reminderList.remove(reminder);

    // _firestore.collection('reminders').document('wgbhYkrUEKDMnsvYTiHZ')
    notifyListeners();
  }

  Reminder? reminderRead({int? index, String? id}) {
    if (index != null) {
      return _reminderList[index];
    } else if (id != null) {
      for (int i = 0; i < _reminderList.length; ++i) {
        if (_reminderList[i].id == id) {
          return _reminderList[i];
        }
      }
      return null;
    } else {
      return null;
    }
  }

  List<Reminder> arrivalAll() {
    return _reminderList
        .where((element) =>
            element.isArrived == true && element.isTracking == true)
        .toList();
  }

  List<Reminder> reminderAll() {
    return _reminderList;
  }

  void setCurrent(Point current) {
    _currentPosition = current;
    notifyListeners();
  }

  Point getCurrent() {
    return _currentPosition;
  }

  void setRinging(bool state) {
    ringing = state;
    notifyListeners();
  }

  void setNotify(bool state) {
    notify = state;
    notifyListeners();
  }

  void setListening(bool state) {
    listening = state;
    notifyListeners();
  }
}
