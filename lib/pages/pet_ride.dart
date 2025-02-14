import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:petify/consts.dart';

class PetRidePage extends StatefulWidget {
  const PetRidePage({super.key});

  @override
  State<PetRidePage> createState() => _PetRidePageState();
}

class _PetRidePageState extends State<PetRidePage> {

  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeedf2),
      body: SafeArea(
        child: RepaintBoundary(
          child: Stack(
            children: [
              _currentPosition == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              color: Color.fromARGB(255, 244, 67, 54)),
                          SizedBox(height: 8),
                          Text("Loading..."),
                        ],
                      ),
                    )
                  : GoogleMap(
                      onMapCreated: (GoogleMapController controller) =>
                          _mapController.complete(controller),
                      initialCameraPosition:
                          CameraPosition(target: _currentPosition!, zoom: 13),
                      markers: Set<Marker>.of(markers.values),
                      polylines: Set<Polyline>.of(polylines.values),
                      onTap: _onMapTapped,
                    ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 70,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPosition != null) {
                      _cameraToPosition(_currentPosition!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 209, 196, 233),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Go to Current Location",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13.5);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        final newPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        if (_currentPosition == null || _currentPosition != newPosition) {
          setState(() {
            _currentPosition = newPosition;
          });

          _updateCurrentLocationMarker();
          if (_destinationPosition != null) {
            _updatePolyline();
          }
        }
      }
    });
  }

  void _updateCurrentLocationMarker() {
    setState(() {
      markers[MarkerId("_currentLocation")] = Marker(
        markerId: MarkerId("_currentLocation"),
        position: _currentPosition!,
        icon: BitmapDescriptor.defaultMarker,
      );
    });
  }

  void _onMapTapped(LatLng tappedPosition) {
    setState(() {
      _destinationPosition = tappedPosition;

      markers[MarkerId("_destinationLocation")] = Marker(
        markerId: MarkerId("_destinationLocation"),
        position: _destinationPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );

      _updatePolyline();
    });
  }

  void _updatePolyline() {
    if (_currentPosition == null || _destinationPosition == null) return;

    getPolylinePoints().then((coordinates) {
      generatePolylineFromPoints(coordinates);
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    if (_currentPosition == null || _destinationPosition == null) {
      return polylineCoordinates;
    }

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(
            _currentPosition!.latitude, _currentPosition!.longitude),
        destination: PointLatLng(
            _destinationPosition!.latitude, _destinationPosition!.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {}
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 33, 149, 243),
      points: polylineCoordinates,
      width: 8,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }
}
