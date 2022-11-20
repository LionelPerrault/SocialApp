// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/route_names.dart';
import 'package:time_elapsed/time_elapsed.dart';

class AdminController extends ControllerMVC {
  factory AdminController([StateMVC? state]) =>
      _this ??= AdminController._(state);
  AdminController._(StateMVC? state) : 
    eventSubRoute = '',
    super(state);
  static AdminController? _this;

  //variable
  List events=[];

  //sub route
  String eventSubRoute;

  @override
  Future<bool> initAsync() async {
    //
    Helper.postData = FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .withConverter<TokenLogin>(
          fromFirestore: (snapshots, _) =>
              TokenLogin.fromJSON(snapshots.data()!),
          toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
        );
    return true;
  }

  Future<List> getEvent() async {
    // QuerySnapshot<TokenLogin> querySnapshot =
    //       await Helper.postData.where('eventPost', isEqualTo: true).get();
    // events = querySnapshot.docs;
    // setState(() { });
    QuerySnapshot querySnapshot =
          await Helper.postData.get();
    var doc = querySnapshot.docs;
    return doc;
  }

  Future<void> createEvent(context,Map<String, dynamic> eventData) async {
    eventData = {
      ...eventData,
      'eventAdmin': UserManager.userInfo['userName'],
      'eventDate': DateTime.now().toString(),
      'eventGoing': false,
      'eventInterested': [],
      'eventInterests': 0,
      'eventInvited': [],
      'eventPost': false,
    };
    await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .add(eventData);
        
    Navigator
      .pushReplacementNamed(
          context,
          RouteNames
              .settings);
  }
  //get all interests from firebase
  Future<List> getAllInterests() async {
    QuerySnapshot querySnapshot =
          await Helper.allInterests.orderBy('title').get();
    var doc = querySnapshot.docs;
    return doc;
  }
}
