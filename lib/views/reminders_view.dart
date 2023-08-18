// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, library_private_types_in_public_api

import 'dart:ui';

import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:flutter_application_demo/views/body_widgets/todays_priorities_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'body_widgets/no_reminders_body.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemindersView extends StatefulWidget {
  const RemindersView({super.key});

  @override
  _RemindersViewState createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
  String greeting = 'Good Day';
  bool _remindersExist = false;

  void getGreeting() {
    TimeOfDay now = TimeOfDay.now();

    greeting = (now.hour <= 12
        ? 'Good Morning'
        : (now.hour <= 17 ? 'Good Afternoon' : 'Good Evening'));
  }

  void checkIfRemindersExist() {
    setState(() {
      _remindersExist = (Provider.of<ReminderDB>(context).reminderList.isEmpty
          ? false
          : true);
    });
  }

  @override
  void initState() {
    getGreeting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );
    checkIfRemindersExist();

    return Padding(
      padding: EdgeInsets.only(left: 7.w, right: 3.w, top: 20.h, bottom: 0.h),
      child: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            height: 20.h,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Hello, $greeting!',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Fantasque',
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0.h),
                  Text(
                    'You have ${Provider.of<ReminderDB>(context).reminderList.length} reminders for today.',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Fantasque',
                    ),
                  ),
                  SizedBox(height: 28.0.h),
                ],
              ),
              (_remindersExist)
                  ? Column(
                      children: const [
                        Text(
                          'Slide right to delete or edit a reminder',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: 'Fantasque',
                          ),
                        ),
                        TodaysPrioritiesBody(),
                      ],
                    )
                  : const NoRemindersBody(),
            ],
          ),
        ]),
      ),
    );
  }
}
