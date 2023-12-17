import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guc_swiss_knife/models/location.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({super.key});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  Location? location;
  final Geodesy _geodesy = Geodesy();
  Position? _currentLocation;
  double _distance = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentLocation = position;
        _calculateDistance();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _calculateDistance() {
    if (_currentLocation != null) {
      LatLng currentLatLng = LatLng(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );

      LatLng targetLatLng = LatLng(
        location!.latitude ?? 0.0,
        location!.longitude ?? 0.0,
      );

      double distance =
          _geodesy.distanceBetweenTwoGeoPoints(currentLatLng, targetLatLng) *
              1.0;
      setState(() {
        _distance = distance;
      });
    }
  }

  // get passed location
  @override
  Widget build(BuildContext context) {
    location = ModalRoute.of(context)!.settings.arguments as Location;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Distance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Target Location: ${location!.name}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Distance: $_distance meters',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
