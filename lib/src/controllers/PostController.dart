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
    pageSubRoute = '',
    super(state);
  static PostController? _this;



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

  /////////////////////////////all support ////////////////////////////////////
  //bool of my friends
  Future<bool> boolMyFriend(String userName) async {
    if (UserManager.userInfo['friends'] != null) {
      var friends = UserManager.userInfo['friends'].where((eachUser) => eachUser['userName'] == userName && eachUser['status']);
      if (friends.length > 0) {
        return true;
      }else {
        return false;
      }
    }else {
      return false;
    }
  }

  //bool of friends of my friends
  Future<bool> boolFriendMyFriend(String userId) async {
    if (UserManager.userInfo['friends'] != null) {
      var myFriends = UserManager.userInfo['friends'];
      var hisFriends = [];
      await Helper.authdata.doc(userId).get().then((value) async {
        hisFriends = value['friends'];
      });
      for (var i = 0; i < myFriends.length; i++) {
        for (var j = 0; j < hisFriends.length; j++) {
          if (myFriends[i]['userName'] == hisFriends[j]['userName'] && myFriends[i]['status'] && hisFriends[j]['status']) {
            return true;
          }
        }
      }
      return false;
    }else {
      return false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  //////////////////////////// start event functions ///////////////////////////////////
  
  //variable
  List events = [];

  //view each event support data
  var event;
  var viewEventId = '';
  var viewEventInterested = false;
  var viewEventGoing = false;
  var viewEventInvited = false;

  //sub router
  String eventTab = 'Timeline';

  //sub route
  String eventSubRoute;


  //get all event function
  Future<List> getEvent(String condition) async {
    List<Map> realAllEvents = [];
    await Helper.eventsData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i<doc.length; i++) {
        var id = doc[i].id;
        var interested = await boolInterested(id);
        var data = doc[i];
        //closed event
        if (data['eventPrivacy'] == 'closed') {
          if (data['eventAdmin']['userName'] == UserManager.userInfo['userName'] && condition == 'manage'){
            realAllEvents.add({'data':data,'id':id, 'interested' : interested});
          }
        }
        //security event
        else /*if (data['eventPrivacy'] == 'security') */{
          var inInterested = await boolInterested(id);
          var inInvited = await boolInvited(id);
          var inGoing = await boolGoing(id);
          if (inInterested && condition == 'interested') {
            realAllEvents.add({'data':data,'id':id, 'interested' : interested});
          }else if (inInvited && condition == 'invited') {
            realAllEvents.add({'data':data,'id':id, 'interested' : interested});
          }else if (inGoing && condition == 'going') {
            realAllEvents.add({'data':data,'id':id, 'interested' : interested});
          }else if (UserManager.userInfo['userName'] == data['eventAdmin']['userName'] && condition == 'manage') {
            realAllEvents.add({'data':data,'id':id, 'interested' : interested});
          }else if (condition == 'all') {
            if (data['eventPrivacy'] == 'public') {
              realAllEvents.add({'data':data,'id':id, 'interested' : interested});
            }
          }
          setState(() { });
        // }
        // //only me
        // // else if (data['eventPrivacy'] == 'onlyme') {
        // //   if (data['eventAdmin']['userName'] == UserManager.userInfo['userName']) {
        // //     realAllEvents.add({'data':data,'id':id, 'interested' : interested});
        // //   }
        // // }
        // //public
        // else if (data['eventPrivacy'] == 'public') {
        }
      }
      print('Now you get all events');
    });
    
    return realAllEvents;
  }

  //get one event function that using uid of firebase database
  Future<bool> getSelectedEvent(String id) async {
    id = id.split('/')[id.split('/').length-1];
    viewEventId = id;
    await Helper.eventsData.doc(id).get().then((value) async {
      event = value;
      viewEventInterested = await boolInterested(id);
      viewEventGoing = await boolGoing(id);
      viewEventInvited = await boolInvited(id);
      setState(() { });
      print('This event was posted by ${event['eventAdmin']}');
    });
    return true;
  }

  //create event function
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
    print('Now you get all interests value to const');
    return doc;
  }
  
  ////////////////////functions that support for making comment to event/////////////////////////////

  //user join in event interested function
  Future<bool> interestedEvent(String eventId) async {
    print('now you are interested or uninterested this event ${eventId}');
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    var respon = await boolInterested(eventId);
    if (respon) {
      interested.removeWhere((item) => item['userName'] == UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInterested': interested});
      return true;
    }else {
      interested.add({'userName': UserManager.userInfo['userName'], 
                    'fullName': '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
                    'userAvatar': UserManager.userInfo['avatar']});
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInterested': interested});
      return true;
    }
  }

  //bool of user already in event interested or not
  Future<bool> boolInterested(String eventId) async {
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    if (interested == null) {
      return false;
    }
    var returnData = interested.where((eachUser) => eachUser['userName'] == UserManager.userInfo['userName']);
    print('you get bool of interested event');
    if (returnData.length == 0) {
      return false;
    }else {
      return true;
    }
  }
  
  //user join in event going function
  Future<bool> goingEvent(String eventId) async {
    print('now you are going or ungoing this event ${eventId}');
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var going = doc['eventGoing'];
    var respon = await boolGoing(eventId);
    if (respon) {
      going.removeWhere((item) => item['userName'] == UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventGoing': going});
      return true;
    }else {
      going.add({'userName': UserManager.userInfo['userName'], 
                    'fullName': '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
                    'userAvatar': UserManager.userInfo['avatar']});
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventGoing': going});
      return true;
    }
    
  }

  //bool of user already in event going or not
  Future<bool> boolGoing(String eventId) async {
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var going = doc['eventGoing'];
    if (going == null) {
      return false;
    }
    var returnData = going.where((eachUser) => eachUser['userName'] == UserManager.userInfo['userName']);
    print('you get bool of going event');
    if (returnData.length == 0) {
      return false;
    }else {
      return true;
    }
  }
  
  //user  join in event invited function
  Future<bool> invitedEvent(String eventId) async {
    print('now you are invited or uninvited this event ${eventId}');
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var invited = doc['eventInvited'];
    var respon = await boolInvited(eventId);
    if (respon) {
      invited.removeWhere((item) => item['userName'] == UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInvited': invited});
      return true;
    }else {
      invited.add({'userName': UserManager.userInfo['userName'], 
                    'fullName': '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
                    'userAvatar': UserManager.userInfo['avatar']});
      await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(eventId)
        .update({'eventInvited': invited});
      return true;
    }
    
  }

  //bool of user already in event invited or not
  Future<bool> boolInvited(String eventId) async {
    var querySnapshot =
          await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var invited = doc['eventInvited'];
    if (invited == null) {
      return false;
    }
    var returnData = invited.where((eachUser) => eachUser['userName'] == UserManager.userInfo['userName']);
    print('you get bool of invited event');
    if (returnData.length == 0) {
      return false;
    }else {
      return true;
    }
  }

  ////////////////////functions that make comment to event/////////////////////////////

  ///////////////////////////end events functions //////////////////////////////////////////////////
  
  //////////////////////////// start event functions ///////////////////////////////////
  
  //variable
  List pages = [];

  //view each event support data
  var page;
  var viewPageId = '';
  var viewPageName = '';
  var viewPageLiked = false;

  //sub router
  String pageTab = 'Timeline';

  //sub route
  String pageSubRoute;


  //get all event function
  Future<List> getPage(String condition) async {
    List<Map> realAllpage = [];
    await Helper.pagesData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i<doc.length; i++) {
        var id = doc[i].id;
        var liked = await boolLiked(id);
        var data = doc[i];
        if (UserManager.userInfo['userName'] == data['pageAdmin']['userName'] && condition == 'manage') {
          realAllpage.add({'data':data,'id':id, 'liked' : liked});
        }else if (condition == 'all') {
          if (data['pagePost']) {
            realAllpage.add({'data':data,'id':id, 'liked' : liked});
          }
        }else if (condition == 'liked' && liked) {
          realAllpage.add({'data':data,'id':id, 'liked' : liked});
        }
        setState(() { });
      }
      print('Now you get all pages');
    });
    
    return realAllpage;
  }

  //get one event function that using uid of firebase database
  Future<bool> getSelectedPage(String name) async {
    name = name.split('/')[name.split('/').length-1];
    print(name);
    // viewPageId = id;
    viewPageName = name;
    print(viewPageName);
    var reuturnValue = await Helper.pagesData.where('pageUserName', isEqualTo: viewPageName).get();
    var value = reuturnValue.docs;
    page = value[0];
    viewPageLiked = await boolLiked(name);
    setState(() { });
    print('This event was posted by ${page['pageAdmin']}');
    return true;
  }

  //create event function
  Future<void> createPage(context,Map<String, dynamic> pageData) async {
    pageData = {
      ...pageData,
      'pageAdmin': {'userName': UserManager.userInfo['userName']},
      'pageDate': DateTime.now().toString(),
      'pageLiked': [],
      'pagePost': false,
      'pagePicture': '',
    };
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .add(pageData);
        
    Navigator
      .pushReplacementNamed(
          context,
          '${RouteNames.pages}/${pageData['pageUserName']}');
  }

  ////////////////////functions that support for making comment to event/////////////////////////////

  //user join in page liked function
  Future<bool> likedPage(String pageId) async {
    print('now you are liked or unliked this event ${pageId}');
    var querySnapshot =
          await Helper.pagesData.doc(pageId).get();
    var doc = querySnapshot;
    var liked = doc['pageLiked'];
    var respon = await boolLiked(pageId);
    if (respon) {
      liked.removeWhere((item) => item['userName'] == UserManager.userInfo['userName']);
      await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .doc(pageId)
        .update({'pageLiked': liked});
      return true;
    }else {
      liked.add({'userName': UserManager.userInfo['userName'], 
                    'fullName': '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
                    'userAvatar': UserManager.userInfo['avatar']});
      await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .doc(pageId)
        .update({'pageLiked': liked});
      return true;
    }
  }

  //bool of user already in event interested or not
  Future<bool> boolLiked(String pageId) async {
    var querySnapshot =
          await Helper.pagesData.where('pageUserName', isEqualTo: viewPageName).get();
    var doc = querySnapshot.docs;
    var liked = doc[0]['pageLiked'];
    if (liked == null) {
      return false;
    }
    var returnData = liked.where((eachUser) => eachUser['userName'] == UserManager.userInfo['userName']);
    print('you get bool of liked page');
    if (returnData.length == 0) {
      return false;
    }else {
      return true;
    }
  }

  ////////////////////functions that make comment to event/////////////////////////////

  ///////////////////////////end events functions //////////////////////////////////////////////////
  
  
}
