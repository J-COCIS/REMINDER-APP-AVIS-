// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, library_private_types_in_public_api, unnecessary_new, deprecated_member_use

import 'package:flutter_application_demo/models/place.dart';
import 'package:flutter_application_demo/utilities/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_demo/utilities/format.dart';

import '../models/reminder_db.dart';
import 'package:provider/provider.dart';

import '../utilities/location.dart';

class ReminderTile extends StatefulWidget {
  final bool isLocationBased;
  final String title;
  final String description;
  final String? id;
  final String? date;
  final String? time;
  final Place? place;
  final double? initialDistance;
  final bool isTracking;
  final bool isArrived;
  final Function edit;
  final Function deleteCallBack;

  ReminderTile({
    required this.title,
    required this.description,
    required this.id,
    required this.date,
    required this.time,
    required this.place,
    required this.initialDistance,
    required this.isLocationBased,
    required this.isTracking,
    required this.isArrived,
    required this.deleteCallBack,
    required this.edit,
  });

  @override
  _ReminderTileState createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {
  final _random = new Random();
  Color? _color;

  void getColor() {
    setState(() {
      _color = colorsList[_random.nextInt(colorsList.length)];
    });
  }

  @override
  void initState() {
    getColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<ReminderDB>(context);
    ScreenUtil.init(context, designSize: const Size(432.0, 816.0));
    FutureBuilder<Place>;
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 110.0.h,
            padding: EdgeInsets.only(
              top: 20.0.h,
              left: 20.0.w,
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: Slidable(
              key: UniqueKey(),
              enabled: true,
              closeOnScroll: true,
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (context) {
                      widget.deleteCallBack();
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.black,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      widget.edit();
                    },
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.black,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              endActionPane:
                  null, // Set the endActionPane as per your requirement
              direction: Axis.horizontal,
              dragStartBehavior: DragStartBehavior.down,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0.h,
                padding: EdgeInsets.only(
                  top: 20.0.h,
                  left: 20.0.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey[200]!, width: 2.0.w),
                  borderRadius: BorderRadius.all(Radius.circular(20.0.h)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0.sp,
                              fontFamily: 'Fantasque',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: 50.0.w,
                          height: 5.0.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0.h),
                              bottomLeft: Radius.circular(10.0.h),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Text(
                        widget.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    widget.isLocationBased
                        ? FutureBuilder<Place>(
                            future: getCurrentLocation(),
                            builder: (BuildContext context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: _color,
                                            size: 15.0.h,
                                          ),
                                          Expanded(
                                            child: Text(
                                              ' ${widget.place!.displayName}',
                                              style: TextStyle(
                                                fontSize: 15.0.sp,
                                                fontFamily: 'Fantasque',
                                                fontWeight: FontWeight.w600,
                                                color: _color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.nordic_walking,
                                            color: _color,
                                            size: 20.0.h,
                                          ),
                                          Text(
                                            '${intFormat(widget.place!.remainderDistance(appStates.getCurrent()).round())} meters away',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                ],
                              );
                            })
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    color: _color,
                                    size: 15.0.h,
                                  ),
                                  Text(
                                    ' ${widget.date}, ${widget.time}',
                                    style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontFamily: 'Fantasque',
                                      fontWeight: FontWeight.w600,
                                      color: _color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
