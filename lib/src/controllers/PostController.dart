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

class PostController extends ControllerMVC {
  factory PostController([StateMVC? state]) =>
      _this ??= PostController._(state);
  PostController._(StateMVC? state) : super(state);
  static PostController? _this;

  //variable
  List events=[];

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

  Future<void> getEvent() async {
    QuerySnapshot<TokenLogin> querySnapshot =
          await Helper.postData.where('eventPost', isEqualTo: true).get();
    events = querySnapshot.docs;
    setState(() { });
  }

  Future<void> createEvent(context,Map<String, dynamic> eventData) async {
    eventData = {
      ...eventData,
      'eventAdmin': UserManager.userInfo['uid'],
      'eventDate': DateTime.now().toString(),
      'eventGoing': false,
      'eventInterested': false,
      'eventInterests': 0,
      'eventInvited': 0,
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
