// ignore_for_file: depend_on_referenced_packages
/**
 
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:provider/provider.dart';

Future<void> writeData(BuildContext context) async {
  final appStates = Provider.of<ReminderDB>(context, listen: false);

  // Write reminders
  await boxReminders.put('len', appStates.reminderAll().length);
  for (int i = 0; i < appStates.reminderAll().length; ++i) {
    await boxReminders.put(i, appStates.reminderAll());
  }

  // Write preferences
  await boxPreferences.put('pre-notify', appStates.notify);
}

Future<void> readData(BuildContext context) async {
  final appStates = Provider.of<ReminderDB>(context, listen: false);

  // Read reminders
  final remindersLen = boxReminders.get('len', defaultValue: 0);
  for (int i = 0; i < remindersLen; ++i) {
    appStates.reminderAll();
  }

  // Read settings
  appStates.setNotify(boxPreferences.get('pre-notify', defaultValue: true));
}


 */
