// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoRemindersBody extends StatelessWidget {
  const NoRemindersBody({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 150,
        ),
        const Text(
          'No reminders',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fantasque',
          ),
        ),
        SizedBox(height: 5.0.h),
        const Text(
          'Create a reminder and it will',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontFamily: 'Fantasque',
          ),
        ),
        const Text(
          'show up here',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontFamily: 'Fantasque',
          ),
        ),
        SizedBox(height: 10.0.h),
        const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
      ],
    );
  }
}
