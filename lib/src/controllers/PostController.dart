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
  PostController._(StateMVC? state) : 
    eventSubRoute = '',
    super(state);
  static PostController? _this;

  //variable
  List events=[];
  var event;
  String eventTab = 'Timeline';
  //sub route
  String eventSubRoute;

  @override
  Future<bool> initAsync() async {
    //
    Helper.eventsData = FirebaseFirestore.instance
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
    //       await Helper.eventsData.where('eventPost', isEqualTo: true).get();
    // events = querySnapshot.docs;
    // setState(() { });
    List<Map> realAllEvents = [];
    await Helper.eventsData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i<doc.length; i++) {
          var id = doc[i].id;
          var interested = await boolInterested(id);
          var data = doc[i];
          realAllEvents.add({'data':data,'id':id, 'interested' : interested});
        }
    });
    
    return realAllEvents;
  }

  Future<bool> getSelectedEvent(String id) async {
    id = id.split('/')[id.split('/').length-1];
    await Helper.eventsData.doc(id).get().then((value) async {
      event = value;
      setState(() { });
      print('This event was posted by ${event['eventAdmin']}');
    });
    return true;
  }

  Future<void> createEvent(context,Map<String, dynamic> eventData) async {
    eventData = {
      ...eventData,
      'eventAdmin': UserManager.userInfo['userName'],
      'eventDate': DateTime.now().toString(),
      'eventGoing': [],
      'eventInterested': [],
      'eventInterests': 0,
      'eventInvited': [],
      'eventPost': false,
      'eventPicture': '',
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
  
  Future<bool> interestedEvent(String eventId) async {
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    var respon = await boolInterested(eventId);
    if (respon) {
      interested.removeWhere((item) => item == UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInterested': interested});
      return true;
    }else {
      interested.add(UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInterested': interested});
      return true;
    }
    
  }

  Future<bool> boolInterested(String eventId) async {
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    if (interested == null) {
      return false;
    }
    var returnData = interested.where((eachUser) => eachUser == UserManager.userInfo['userName']);
    if (returnData.length == 0) {
      return false;
    }else {
      return true;
    }
  }
}
