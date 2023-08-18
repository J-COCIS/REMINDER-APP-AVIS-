// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, library_private_types_in_public_api

import 'dart:async';
import 'dart:collection';
import 'package:flutter_application_demo/utilities/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var latitude = 19.109906;
var longitude = 72.867671;

class MapContainer extends StatefulWidget {
  final double width;

  const MapContainer({super.key, required this.width});

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  final Set<Marker> _currentLocationMarkerPin = HashSet<Marker>();
  final Set<Circle> _circularArea = HashSet<Circle>();
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.0,
  );

  Future getLocationData() async {
    LocationService locationService = LocationService();

    //Fetching _userLocation
    latitude = (await locationService.getLat());
    longitude = (await locationService.getLat());
    setState(() {});
  }

  void getCurrentLocationMarkerPin() {
    setState(() {
      _currentLocationMarkerPin.add(
        Marker(
          markerId: const MarkerId("0"),
          position: LatLng(latitude, longitude),
        ),
      );
    });
  }

  void getCircularArea() {
    _circularArea.add(
      Circle(
        circleId: const CircleId("0"),
        center: LatLng(latitude, longitude),
        radius: 1000,
        strokeWidth: 2,
        strokeColor: Colors.blueAccent,
        fillColor: Colors.blueAccent.withOpacity(0.3),
      ),
    );
  }

  @override
  void initState() {
    getLocationData();
    super.initState();

    getCircularArea();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return Container(
      width: widget.width.w,
      height: 271.0.h,
      margin: EdgeInsets.only(top: 5.0.h),
      child: GoogleMap(
        mapType: MapType.normal,
        circles: _circularArea,
        markers: _currentLocationMarkerPin,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          getCurrentLocationMarkerPin();
        },
      ),
    );
  }
}
