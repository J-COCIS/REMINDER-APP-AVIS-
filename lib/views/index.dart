// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:flutter_application_demo/models/check_if_user_logged_in.dart';
import 'package:flutter_application_demo/widgets/bottom_reminder_modal_sheet.dart';
import 'package:flutter_application_demo/widgets/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/reminder_db.dart';
import '../utilities/location.dart';
import '../utilities/routing_constants.dart';
import 'account_view.dart';
import 'body_widgets/profile_body.dart';
import 'reminders_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_demo/utilities/database_ops.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> with WidgetsBindingObserver {
  int _index = 0;

  // int _index = 1;
  final List<Widget> _widgetList = [
    const RemindersView(),
    const AccountView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    positionStream.cancel();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    writeData(context);
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        readData(context);
        break;
      case AppLifecycleState.paused:
        writeData(context);
        break;
      case AppLifecycleState.detached:
        writeData(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<ReminderDB>(context);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        if (appStates.listening == false) {
          getCurrentLocation().then((value) {
            appStates.setCurrent(value.position);
            handlePositionUpdates(context);
            appStates.setListening(true);
          });
        }
      }
    });

    ScreenUtil.init(
      context,
      designSize: Size(_width, _height),
    );

    return ChangeNotifierProvider<CheckIfUserLoggedIn>(
      create: (context) => CheckIfUserLoggedIn(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.amber,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0.h,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: const Text(
                'Avis',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontFamily: 'Fantasque',
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                Container(
                  width: _width - 290.0.w,
                  margin: EdgeInsets.only(right: 20.0.w, top: 5.0.h),
                  child: IconButton(
                    iconSize: 40.0,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, kSearchView);
                      });
                    },
                  ),
                ),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),

            body: _widgetList[_index],
            bottomNavigationBar: FABBottomAppBar(
              centerItemText: 'Add Reminder',
              color: Colors.black,
              backgroundColor: Colors.white,
              selectedColor: Colors.blue,
              notchedShape: const CircularNotchedRectangle(),
              onTabSelected: (index) {
                setState(() {
                  _index = index;
                });
              },
              items: [
                FABBottomAppBarItem(iconData: Icons.menu, text: 'Reminders'),
                FABBottomAppBarItem(iconData: Icons.face, text: 'Account'),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (checkIfUserLoggedIn.getCurrentUser()) {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Wrap(
                        children: [
                          BottomReminderSheet(),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'User Access!!!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 243, 35, 20),
                            fontFamily: 'Fantasque',
                          ),
                        ),
                        content: const Text(
                          'Please User login or signup first ',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Fantasque',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 5.0,
                            ),
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Fantasque',
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              highlightElevation: 3.0.h,
              elevation: 2.0.h,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            extendBody:
                true, // ensures that that scaffold's body will be visible through the bottom navigation bar's notch
          ),
        ],
      ),
    );
  }
}
