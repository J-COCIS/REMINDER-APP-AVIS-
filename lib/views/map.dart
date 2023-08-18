// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_demo/models/place.dart';
import 'package:flutter_application_demo/models/point.dart';
import 'package:flutter_application_demo/models/repository/maps.dart';
import 'package:flutter_application_demo/utilities/location.dart';
import 'package:flutter_application_demo/widgets/buttons.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Place> _options = <Place>[];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.mapEventStream.listen((event) async {
      if (event is MapEventMoveEnd) {
        // Handle event.center.
      }
    });
  }

  @override
  void dispose() async {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: const Text(
          'Pick Destination',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontFamily: 'Fantasque',
            fontWeight: FontWeight.w500,
          ),
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
      body: SafeArea(
        child: FutureBuilder<Place>(
            future: getCurrentLocation(),
            builder: (BuildContext context, AsyncSnapshot<Place> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(
                            snapshot.data!.position.latitude,
                            snapshot.data!.position.longitude,
                          ),
                          zoom: 15,
                          maxZoom: 18,
                          minZoom: 0,
                          keepAlive: true,
                        ),
                        mapController: _mapController,
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.5,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Text(
                                _searchController.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  fontFamily: 'Fantasque',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: Center(
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.deepPurple,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 224,
                      right: 8,
                      child: ZoomInFloatingButton(
                        onPressed: () {
                          _mapController.move(
                              _mapController.center, _mapController.zoom + 1);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 152,
                      right: 8,
                      child: ZoomOutFloatingButton(
                        onPressed: () {
                          _mapController.move(
                              _mapController.center, _mapController.zoom - 1);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      right: 8,
                      child: MyLocationFloatingButton(
                        onPressed: () async {
                          final currentLocation =
                              await getCurrentLocation().onError(
                            (error, stackTrace) =>
                                Future.error(error!, stackTrace),
                          );
                          _mapController.move(
                            LatLng(
                              currentLocation.position.latitude,
                              currentLocation.position.longitude,
                            ),
                            _mapController.zoom,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(4),
                            hintText: 'Search Location',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Fantasque',
                              fontSize: 18,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (String value) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }

                            _debounce = Timer(
                              const Duration(seconds: 1),
                              () async {
                                try {
                                  _options = await Maps()
                                      .searchLocation(value)
                                      .onError(
                                        (error, stackTrace) =>
                                            Future.error(error!, stackTrace),
                                      );
                                } finally {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              },
                            );
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'NotoArabic',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 57,
                      right: 8,
                      left: 8,
                      height: _options.length < 6
                          ? _options.length * 80
                          : _options.length > 6
                              ? MediaQuery.of(context).size.height / 2 - 32
                              : null,
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: StatefulBuilder(
                          builder: ((context, setState) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: _options.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    _options[index].displayName!,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoArabic',
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_options[index].position.latitude}, ${_options[index].position.longitude}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Fantasque',
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _mapController.move(
                                      LatLng(
                                        _options[index].position.latitude,
                                        _options[index].position.longitude,
                                      ),
                                      15.0,
                                    );

                                    _focusNode.unfocus();
                                    _options.clear();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectDestinationButton(onPressed: () async {
                            final Point position = Point(
                              latitude: _mapController.center.latitude,
                              longitude: _mapController.center.longitude,
                            );
                            await Maps()
                                .getLocationInfo(position)
                                .then((value) {
                              if (mounted) {
                                Navigator.of(context).pop<Place>(value);
                              }
                            }).onError(
                              (error, stackTrace) =>
                                  Future.error(error!, stackTrace),
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else {
                  return const Center(
                    child: Expanded(
                      child: Text(
                        "Failed to load data!, Please check your internet connection and try again",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Fantasque',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
              }
            }),
      ),
    );
  }
}
