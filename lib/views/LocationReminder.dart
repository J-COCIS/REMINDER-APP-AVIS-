// ignore_for_file: depend_on_referenced_packages, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables, unnecessary_new, prefer_const_constructors, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:flutter_application_demo/models/place.dart';
import 'package:flutter_application_demo/models/point.dart';
import 'package:flutter_application_demo/models/reminder.dart';
import 'package:flutter_application_demo/models/repository/maps.dart';
import 'package:flutter_application_demo/widgets/buttons.dart';
import 'package:flutter_application_demo/views/map.dart';
import 'package:flutter_application_demo/utilities/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class SetLocationView extends StatefulWidget {
  SetLocationView({
    Key? key,
    this.title = '',
    this.latitude = '',
    this.longitude = '',
    this.radius = '',
    this.description,
    this.id,
    this.isTracking = true,
    this.appBarTitle = 'New Location Reminder',
  }) : super(key: key);

  String title;
  String latitude;
  String longitude;
  String radius;
  String? description;
  String? id;
  String appBarTitle;
  bool isTracking;

  @override
  State<SetLocationView> createState() => LocationView();
}

class LocationView extends State<SetLocationView> {
  final _locationFormKey = GlobalKey<FormState>();
  final _titleFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    _titleController.text = widget.title;
    _latitudeController.text = widget.latitude;
    _longitudeController.text = widget.longitude;
    _radiusController.text = widget.radius;
    _descriptionController.text = widget.description ?? '';
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
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    _descriptionController.dispose();
  }

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

  Future<void> scheduleNotificationBasedOnLocation() async {
    final appStates = Provider.of<ReminderDB>(context, listen: false);
    int notificationId = generateRandomId();
    var android = new AndroidNotificationDetails(
        'ScheduledNotification001', 'Notify Me',
        priority: Priority.high, importance: Importance.high);
    var iOS = new DarwinInitializationSettings();
    var platform = new NotificationDetails(android: android);

    return await flutterLocalNotificationsPlugin.show(notificationId,
        _titleController.text, _descriptionController.text, platform,
        payload: 'Your Reminder!');

    /**
   final reminders = appStates.reminderAll();

    for (int i = 0; i < reminders.length; ++i) {
      if (reminders[i].isTracking == true) {
        final remainderDistance =
            reminders[i].remainderDistance(appStates.getCurrent());
        final radius = reminders[i].place!.radius;
        if (remainderDistance <= radius!) {
          return await flutterLocalNotificationsPlugin.show(notificationId,
              _titleController.text, _descriptionController.text, platform,
              payload: 'Your Reminder!');
        }
      }
    }
   */
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<ReminderDB>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(
            fontFamily: 'Fantasque',
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _titleFormKey,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: _titleController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            filled: true,
                            errorStyle: TextStyle(
                              fontFamily: 'Fantasque',
                              color: Colors.redAccent,
                            ),
                            hintText: 'Title...',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Fantasque',
                              color: Colors.black,
                            )),
                        style: const TextStyle(
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: const Text(
                        'Set Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key: _locationFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: _latitudeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                filled: true,
                                errorStyle: TextStyle(
                                  fontFamily: 'Fantasque',
                                ),
                                hintText: 'lat coordinate',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^[+\-]?[0]{1}[^.]')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Fantasque',
                                color: Colors.black,
                              ),
                              validator: (value) {
                                return pointValidate(
                                  value,
                                  message: 'Invalid latitude',
                                  limit: 90,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: _longitudeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                filled: true,
                                errorStyle: TextStyle(
                                  fontFamily: 'Fantasque',
                                  color: Colors.redAccent,
                                ),
                                hintText: 'long coordinate',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^[+\-]?[0]{1}[^.]')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Fantasque',
                                color: Colors.black,
                              ),
                              validator: (value) {
                                return pointValidate(
                                  value,
                                  message: 'Invalid longitude',
                                  limit: 180,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ChooseOnMapButton(
                      onPressed: () async {
                        final pickedLocation =
                            await Navigator.of(context).push<Place>(
                          MaterialPageRoute<Place>(
                            builder: (context) {
                              return const MapPage();
                            },
                          ),
                        );

                        if (pickedLocation != null) {
                          if (mounted) {
                            setState(() {
                              _latitudeController.text =
                                  pickedLocation.position.latitude.toString();
                              _longitudeController.text =
                                  pickedLocation.position.longitude.toString();
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: _radiusController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        filled: true,
                        hintText: 'radius',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                        suffixText: 'Meters',
                        suffixStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Fantasque',
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^[0-9]{1,7})')),
                        FilteringTextInputFormatter.deny(
                            RegExp(r'(^[0-9]{8,})')),
                        FilteringTextInputFormatter.deny(
                            RegExp(r'(^[0]{1}[0-9]+)')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Fantasque',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          filled: true,
                          hintText: 'Your notes/description here...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          )),
                      style: const TextStyle(
                        fontFamily: 'Fantasque',
                        fontSize: 20,
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 32,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AddReminderButton(
                buttonText:
                    widget.id != null ? ' Save Reminder' : ' Add Reminder',
                onPressed: () async {
                  // Validate inputs
                  if (_titleController.text.isEmpty) {
                    _titleFormKey.currentState!.validate();
                    return;
                  }

                  if (_latitudeController.text.isEmpty ||
                      _longitudeController.text.isEmpty) {
                    _locationFormKey.currentState!.validate();
                    return;
                  }

                  Point position = Point(
                    latitude: double.parse(_latitudeController.text),
                    longitude: double.parse(_longitudeController.text),
                  );

                  final destination = await Maps()
                      .getLocationInfo(position)
                      .onError((error, stackTrace) {
                    return Future.error(error!, stackTrace);
                  });

                  if (_radiusController.text.isEmpty) {
                    if (mounted) {
                      setState(() {
                        _radiusController.text = destination.radius.toString();
                      });
                    }
                  }
                  destination.radius = int.parse(_radiusController.text);

                  if (widget.id == null) {
                    Reminder newReminder = Reminder(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      date: null,
                      time: null,
                      place: destination,
                      initialDistance: 0.0,
                      isTracking: true,
                      isArrived: false,
                    );

                    Provider.of<ReminderDB>(context, listen: false)
                        .addReminderBasedOnLocation(
                      _titleController.text,
                      _descriptionController.text,
                      destination,
                      0.0,
                      true,
                      false,
                    );

                    // Update the initial distance
                    newReminder.traveledDistance(position);
                    appStates.addReminderBasedOnLocation;
                  } else {
                    final oldReminder = appStates.reminderRead(id: widget.id)!;
                    final newReminder = oldReminder.copy(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      place: destination,
                      initialDistance: 0.0,
                    );

                    newReminder.traveledDistance(position);
                    appStates.reminderUpdate(newReminder);
                    appStates.deleteReminder(oldReminder);

                    Provider.of<ReminderDB>(context, listen: false)
                        .addReminderBasedOnLocation(
                      _titleController.text,
                      _descriptionController.text,
                      destination,
                      0.0,
                      true,
                      false,
                    );
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop<void>();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
