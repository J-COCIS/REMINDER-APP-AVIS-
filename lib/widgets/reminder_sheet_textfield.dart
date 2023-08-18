// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ReminderSheetTextField extends StatelessWidget {
  final TextEditingController taskTextController;
  String text;
  final String hintText;

  ReminderSheetTextField({
    super.key,
    required this.taskTextController,
    required this.text,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return TextField(
      controller: taskTextController,
      autocorrect: true,
      // autofocus:
      //     true, //To automatically enable the textfield and show keyboard
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0.h),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0.h),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      onChanged: (value) {
        text = value;
      },
    );
  }
}
