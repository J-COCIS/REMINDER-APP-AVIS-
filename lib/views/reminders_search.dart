// ignore_for_file: unnecessary_null_comparison, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/models/reminder_db.dart';
import 'package:flutter_application_demo/models/reminder.dart';
import 'package:provider/provider.dart';

class RemindersSearch extends StatefulWidget {
  const RemindersSearch({super.key});

  @override
  State<RemindersSearch> createState() => _RemindersSearch();
}

class _RemindersSearch extends State<RemindersSearch> {
  final _search = TextEditingController();
  List<Reminder> _matched = <Reminder>[];
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<ReminderDB>(context);

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          focusNode: _focusNode,
          controller: _search,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
            labelStyle: const TextStyle(color: Colors.black),
            isDense: true,
            suffix: IconButton(
              onPressed: () {
                _search.clear();
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
            ),
          ),
          onChanged: (value) {
            final reminders = appStates.reminderAll();
            final matched = <Reminder>[];
            for (int i = 0; i < reminders.length; ++i) {
              if (reminders[i].title.contains(value)) {
                matched.add(reminders[i]);
              } else if (reminders[i].place!.displayName != null &&
                  reminders[i].place!.displayName!.contains(value)) {
                matched.add(reminders[i]);
              } else if (reminders[i].description != null &&
                  reminders[i].description.contains(value)) {
                matched.add(reminders[i]);
              }
            }
            if (mounted) {
              setState(() {
                _matched = matched;
              });
            }
          },
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
      body: ListView.builder(
        itemCount: _matched.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {},
              child: ListTile(
                dense: true,
                leading: Icon(
                  Icons.location_pin,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                subtitle: Text(
                  _matched[index].place!.displayName!,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Fantasque',
                  ),
                ),
                title: Text(
                  _matched[index].title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'NotoArabic',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
