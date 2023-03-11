import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/routes/route_names.dart';

import '../helpers/helper.dart';

class GeolocationManager {
  static LatLng searchPoint = const LatLng(0, 0);
  static LatLng choosePoint = const LatLng(0, 0);

  static var timer = null;

  static void startGeoTimer() {
    if (timer != null) return;

    _getCurrentPosition();
    timer = Timer.periodic(Duration(seconds: 60), (timer) {
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













/*
http
.post(
  Uri.parse(
      'https://api.relysia.com/v1/send?serviceID=9ab1b61e-92ae-4612-9a4f-c5a102a6c068&authToken=$token'),
  headers: {
    'authToken': '$token',
    'content-type': 'application/json',
    'serviceID': '9ab1b69e-92ae-4612-9a4f-c5a102a6c068'
  },
  body:
      '{ "dataArray" : [{"to" : "4064@shnatter.com","amount" : 10,"tokenId" : "$token_id"}]}',
)
*/