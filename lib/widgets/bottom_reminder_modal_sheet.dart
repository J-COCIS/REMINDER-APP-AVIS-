// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_const_constructors, unnecessary_new, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, must_be_immutable

import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:flutter_application_demo/utilities/location_service.dart';
import 'package:flutter_application_demo/utilities/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/reminder.dart';

class BottomReminderSheet extends StatefulWidget {
  BottomReminderSheet({
    Key? key,
    this.id,
    this.title = '',
    this.description = '',
    this.date = '',
    this.time = '',
    this.isTracking = false,
    this.appBarTitle = 'Add Reminder',
  }) : super(key: key);

  String title;

  String description;
  String date;
  String time;
  String? id;
  String appBarTitle;
  bool isTracking;

  @override
  BottomReminderSheetState createState() => BottomReminderSheetState();
}

var userLocation;

class BottomReminderSheetState extends State<BottomReminderSheet> {
  LocationService locationService = LocationService();
  bool _isEdit = false;
  bool _isSwitched = false;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final _titleFormKey = GlobalKey<FormState>();
  final _descFormKey = GlobalKey<FormState>();
  final _dateFormKey = GlobalKey<FormState>();
  final _timeFormKey = GlobalKey<FormState>();

  DateTime dateTime = DateTime.now();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _title.text = widget.title;
    _date.text = widget.date;
    _time.text = widget.time;
    _desc.text = widget.description;
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('reminder');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(onDidReceiveLocalNotification: null);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _date.dispose();
    _time.dispose();
    _desc.dispose();
  }

// ignore: missing_return
  Future<void> onSelectNotification(response) async {
    print('payload $response');
    if (response?.payload != null && response!.payload!.isNotEmpty) {
      var onNotificationClick;
      onNotificationClick.add(response.payload);
    }
  }

  int generateRandomId() {
    Random random = Random();
    int randomNumber = random
        .nextInt(1000000); // Generate a random number between 0 and 999999
    return randomNumber;
  }

  scheduleNotificationBasedOnTime() {
    const AndroidNotificationDetails androidNoticationDetails =
        AndroidNotificationDetails(
      'ScheduledNotification001',
      'Notify Me',
      importance: Importance.high,
    );
    const DarwinInitializationSettings iosNotificationDetails =
        DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNoticationDetails,
      iOS: null,
    );

    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);

    // Generate a random ID for the notification
    int notificationId = generateRandomId();

    flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      _title.text,
      _desc.text,
      scheduledAt,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<ReminderDB>(context, listen: false);

    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return Container(
      padding: EdgeInsets.all(30.0.h),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0.w),
          topRight: Radius.circular(30.0.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Text(
              widget.appBarTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                fontFamily: 'Fantasque',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0.h),
            child: Column(
              children: [
                Visibility(
                  visible: !_isSwitched,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _titleFormKey,
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: _title,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          label: const Text(
                            'Reminder Title',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0.h),
                Visibility(
                  visible: !_isSwitched,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _descFormKey,
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: _desc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          label: const Text(
                            'Reminder Description',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0.h),
                Visibility(
                  visible: !_isSwitched,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _dateFormKey,
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: _date,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: InkWell(
                            child: const Icon(
                              Icons.date_range,
                              color: Colors.black,
                            ),
                            onTap: () async {
                              final DateTime? newlySelectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: dateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2095),
                              );
                              if (newlySelectedDate == null) {
                                return;
                              }

                              setState(() {
                                dateTime = newlySelectedDate;
                                _date.text =
                                    "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                              });
                            },
                          ),
                          label: const Text(
                            'Date',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 13.0.h),
                Visibility(
                  visible: !_isSwitched,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _timeFormKey,
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: _time,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: InkWell(
                            child: const Icon(
                              Icons.timer_outlined,
                              color: Colors.black,
                            ),
                            onTap: () async {
                              final TimeOfDay? SelectedTime =
                                  await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                              if (SelectedTime == null) {
                                return;
                              }

                              _time.text =
                                  '${SelectedTime.hour}:${SelectedTime.minute}';

                              DateTime newDT = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                SelectedTime.hour,
                                SelectedTime.minute,
                              );

                              setState(() {
                                dateTime = newDT;
                              });
                            },
                          ),
                          label: const Text(
                            'Time',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'time is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            'Remind me at a location',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Fantasque',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        FlutterSwitch(
                          width: 48.0.w,
                          height: 28.0.h,
                          valueFontSize: 20.0,
                          toggleSize: 22.0.h,
                          value: _isSwitched,
                          borderRadius: 30.0.w,
                          inactiveColor: Colors.black,
                          activeColor: Colors.lightBlueAccent,
                          onToggle: (val) {
                            setState(() {
                              _isSwitched = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0.h),
                    Visibility(
                      visible: _isSwitched,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, kSetLocationView);
                                },
                                child: const Text(
                                  'Add Location',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Fantasque',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    size: 24.h, color: Colors.black),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, kSetLocationView);
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, kWeatherView);
                                },
                                child: const Text(
                                  'View Weather',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Fantasque',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    size: 24.h, color: Colors.black),
                                onPressed: () {
                                  Navigator.pushNamed(context, kWeatherView);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isSwitched,
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonMinWidth: 150.0.w,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.only(
                      left: 15,
                      bottom: 11,
                      top: 11,
                      right: 15,
                    ),
                  ),
                  onPressed: () async {
                    if (_title.text.isEmpty) {
                      _titleFormKey.currentState!.validate();
                      return;
                    }
                    if (_desc.text.isEmpty) {
                      _descFormKey.currentState!.validate();
                      return;
                    }

                    if (_date.text.isEmpty) {
                      _dateFormKey.currentState!.validate();
                      return;
                    }
                    if (_time.text.isEmpty) {
                      _timeFormKey.currentState!.validate();
                      return;
                    } else {
                      // Reminder based on location
                      if (_isSwitched) {
                        return;
                      } else {
                        if (widget.id == null) {
                          Reminder newReminder = Reminder(
                            id: const Uuid().v4(),
                            title: _title.text,
                            description: _desc.text,
                            date: _date.text,
                            time: _time.text,
                            place: null,
                            initialDistance: null,
                            isTracking: false,
                            isArrived: false,
                          );

                          scheduleNotificationBasedOnTime();
                          Provider.of<ReminderDB>(context, listen: false)
                              .addReminder(
                            _title.text,
                            _desc.text,
                            _date.text,
                            _time.text,
                          );

                          _title.clear();
                          _desc.clear();
                          _date.clear();
                          _time.clear();
                        } else {
                          final oldReminder =
                              appStates.reminderRead(id: widget.id)!;
                          final newReminder = oldReminder.copy(
                            title: _title.text,
                            description: _desc.text,
                            date: _date.text,
                            time: _time.text,
                          );

                          appStates.reminderUpdate(newReminder);

                          scheduleNotificationBasedOnTime();
                        }
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop<void>();
                      }
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 221, 14, 14),
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.only(
                      left: 15,
                      bottom: 11,
                      top: 11,
                      right: 15,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100.0.h),
        ],
      ),
    );
  }
}
