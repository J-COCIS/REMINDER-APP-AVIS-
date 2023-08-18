// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter_application_demo/models/check_if_user_logged_in.dart';
import 'package:flutter_application_demo/utilities/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

CheckIfUserLoggedIn checkIfUserLoggedIn = CheckIfUserLoggedIn();
String? email = checkIfUserLoggedIn.getCurrentUserEmail();

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  LocationService locationService = LocationService();
  var _userLocation = 'Processing.....';
  bool _isLoading = false;

  Future<void> signOut(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    checkIfUserLoggedIn.SignOut();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          _isLoading = false;
        });
      },
    );
    setState(() {
      Provider.of<CheckIfUserLoggedIn>(context, listen: false)
          .changeState(true);
    });
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Replace with your login screen route
      (Route<dynamic> route) => false, // Remove all routes from the stack
    );
  }

  //Needs to be future!
  Future getLocationData() async {
    //Fetching _userLocation
    _userLocation = (await locationService.getLocation());
    setState(() {});
  }

  @override
  void initState() {
    getLocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
      child: Stack(children: [
        Opacity(
          opacity: _isLoading ? 1.0 : 0.0,
          child: const Center(child: CircularProgressIndicator()),
        ),
        ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  ' Welcome User,',
                  style: TextStyle(
                    fontSize: 30.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Fantasque',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0.h),
                const Text(
                  'Your reminders are now going to be synced on all devices.',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Fantasque',
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30.0.h),
                  width: 200.0.w,
                  height: 200.0.h,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Email used:  ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        email!,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0.h),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Current Location:  ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _userLocation,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Fantasque',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 38.0.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0.h,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0.h),
                    ),
                    padding: EdgeInsets.only(
                      left: 15.w,
                      bottom: 11.h,
                      top: 11.h,
                      right: 15.w,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      signOut(context);
                    });
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0.h),
                const Text(
                  'If you want to sign out of Avis App,click Sign Out.',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Fantasque',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
