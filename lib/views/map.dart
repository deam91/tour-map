import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour/constants/global.dart';
import 'package:tour/services/location.dart';

class AnimatedTourMap extends StatefulWidget {
  const AnimatedTourMap({Key? key}) : super(key: key);

  @override
  _AnimatedTourMapState createState() {
    return _AnimatedTourMapState();
  }
}

class _AnimatedTourMapState extends State<AnimatedTourMap>
    with SingleTickerProviderStateMixin {
  var _myLocation;
  final _pageController = PageController();
  late final AnimationController _animationController;
  int _selectedIndex = -1;

  @override
  initState() {
    _currentPosition();
    _animationController =
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();
    return Stack(
      children: [
        _myLocation != null
            ? FlutterMap(
          options: MapOptions(
              minZoom: 13, maxZoom: 20, zoom: 13, center: _myLocation),
          nonRotatedLayers: [
            TileLayerOptions(
                urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': MAP_BOX_API_KEY,
                  'id': MAP_BOX_STYLE
                }),
            MarkerLayerOptions(markers: [
              Marker(
                  height: 60,
                  width: 60,
                  point: _myLocation,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {
                        print('selected my position');
                      },
                      child: MyLocationMarker(_animationController),
                    );
                  })
            ]),
            MarkerLayerOptions(markers: _markers)
          ],
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 15,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _markers.length,
              itemBuilder: (context, index) {
                final item = markers[index];
                return _MapItemDetails(mapMarker: item);
              }),
        )
      ],
    );
  }

  _currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      _myLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  _buildMarkers() {
    final _list = <Marker>[];
    if (_myLocation != null) {
      for (var i = 0; i < markers.length; i++) {
        final mapItem = markers[i];
        _list.add(Marker(
            height: MARKER_SIZE_EXPANDED,
            width: MARKER_SIZE_EXPANDED,
            point: mapItem.location,
            builder: (_) {
              return GestureDetector(
                onTap: () {
                  _selectedIndex = i;
                  setState(() {
                    _pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut);
                  });
                },
                child: _LocationMarker(
                  selected: _selectedIndex == i,
                ),
              );
            }));
      }
    }
    return _list;
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({Key? key, this.selected = false}) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
    return Center(
      child: AnimatedContainer(
        height: size,
        width: size,
        duration: const Duration(milliseconds: 400),
        child: Image.asset('assets/markers/marker_place.png'),
      ),
    );
  }
}

class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(Animation<double> animation, {
    Key? key,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.5, 1, value)!;
    final size = 40.0;
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: size * newValue,
              width: size * newValue,
              decoration: BoxDecoration(
                  color: MARKER_COLOR.withOpacity(0.5), shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              height: 15,
              width: 15,
              decoration: const BoxDecoration(
                  color: MARKER_COLOR, shape: BoxShape.circle),
            ),
          )
        ],
      ),
    );
  }
}

class _MapItemDetails extends StatelessWidget {
  final MapMarker mapMarker;

  const _MapItemDetails({Key? key, required this.mapMarker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleDescription = TextStyle(color: Colors.grey[800], fontSize: 16);
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Image.asset(mapMarker.image)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mapMarker.title, style: _styleTitle),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(mapMarker.description, style: _styleDescription),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(mapMarker.address, style: _styleAddress)
                      ],
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width - 50,
              padding: EdgeInsets.zero,
              onPressed: () => null,
              color: MARKER_COLOR,
              elevation: 6,
              child:
              Text('CALL', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
