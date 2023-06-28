import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/helper.dart';

class GeolocationManager {
  static LatLng searchPoint = const LatLng(0, 0);
  static LatLng choosePoint = const LatLng(0, 0);

  static var timer;

  static void startGeoTimer() {
    if (timer != null) return;

    _getCurrentPosition();
    timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _getCurrentPosition();
    });
  }

  static void stopGeoTimer() {
    timer.cancel();
    timer = null;
  }

  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Helper.showToast(
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Helper.showToast('Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Helper.showToast(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  static Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      searchPoint = LatLng(position.latitude, position.longitude);
      choosePoint = LatLng(position.latitude, position.longitude);

      Helper.updateGeoPoint(position.latitude, position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
