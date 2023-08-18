// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, library_private_types_in_public_api

import 'package:flutter_application_demo/models/point.dart';
import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/place.dart';
import 'models/reminder.dart';
import 'utilities/router.dart' as router;
import 'utilities/routing_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize hive databases
  await Hive.initFlutter();

  Hive.registerAdapter<Reminder>(ReminderAdapter());
  Hive.registerAdapter<Place>(PlaceAdapter());
  Hive.registerAdapter<Point>(PointAdapter());

  boxReminders = await Hive.openBox('reminders');

  runApp(const Checklst());
}

class Checklst extends StatefulWidget {
  const Checklst({super.key});

  @override
  _ChecklstState createState() => _ChecklstState();
}

class _ChecklstState extends State<Checklst> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReminderDB>(
      create: (_) {
        return ReminderDB();
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,

        // Pass the generateRoute function to onGenerateRoute
        // To define the home view as the starting view, instead of setting the home property to a widget we’ll use initialRoute instead.
        // initialRoute: ... vs home: ...
        onGenerateRoute: router.generateRoute,
        // initialRoute: kLocationSelectionView,
        initialRoute: kIndexView,
      ),
    );
  }
}
