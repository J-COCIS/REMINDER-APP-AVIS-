// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, unnecessary_new, unnecessary_null_comparison

import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:flutter_application_demo/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/bottom_reminder_modal_sheet.dart';
import '../LocationReminder.dart';

class TodaysPrioritiesBody extends StatefulWidget {
  const TodaysPrioritiesBody({super.key});

  @override
  _TodaysPrioritiesBodyState createState() => _TodaysPrioritiesBodyState();
}

class _TodaysPrioritiesBodyState extends State<TodaysPrioritiesBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _rebuild() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _rebuild,
      child: Container(
        height: 550.0,
        child: Consumer<ReminderDB>(
          builder: (context, reminderDB, child) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final simple = reminderDB.reminderList[index];
                return ReminderTile(
                  id: const Uuid().v4(),
                  title: simple.title,
                  description: simple.description,
                  date: simple.date,
                  time: simple.time,
                  place: simple.place,
                  initialDistance: simple.initialDistance,
                  isLocationBased: simple.place != null ? true : false,
                  isTracking: simple.isTracking,
                  isArrived: simple.isArrived,
                  edit: () {
                    if (simple.isTracking == true) {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) {
                            return SetLocationView(
                              appBarTitle: 'Edit Reminder',
                              title: simple.title,
                              description: simple.description,
                              latitude:
                                  simple.place!.position.latitude.toString(),
                              longitude:
                                  simple.place!.position.longitude.toString(),
                              radius: simple.place!.radius.toString(),
                              id: simple.id,
                            );
                          },
                        ),
                      );
                    } else {
                      Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(builder: (context) {
                        return BottomReminderSheet(
                          appBarTitle: 'Edit Reminder',
                          title: simple.title,
                          description: simple.description,
                          date: simple.date!,
                          time: simple.time!,
                          id: simple.id,
                        );
                      }));
                    }
                    reminderDB.reminderUpdate(simple);
                  },
                  deleteCallBack: () {
                    reminderDB.deleteReminder(simple);
                  },
                );
              },
              itemCount: reminderDB.reminderList.length,
            );
          },
        ),
      ),
    );
  }
}
