// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/relysia_manager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventTimelineScreen.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../views/profile/model/friends.dart';

enum PostType { timeline, profile, event, group }

class AdminController extends ControllerMVC {
  factory AdminController([StateMVC? state]) =>
      _this ??= AdminController._(state);
  AdminController._(StateMVC? state) : super(state);
  static AdminController? _this;

  // List<mvc.StateMVC> notifiers;

  @override
  Future<bool> initAsync() async {
    return true;
  }

  int usersNum = 0;
  int postsNum = 0;
  int eventsNum = 0;
  int groupsNum = 0;
  int onlineUsers = 0;
  getBodyData() async {
    QuerySnapshot usersSnap = await Helper.userCollection.get();
    QuerySnapshot eventsSnap = await Helper.eventsData.get();
    QuerySnapshot groupsSnap = await Helper.groupsData.get();
    QuerySnapshot onlineUsersSnap = await FirebaseFirestore.instance
        .collection(Helper.onlineStatusField)
        .where('status', isEqualTo: 1)
        .get();
    usersNum = usersSnap.docs.length;
    postsNum = eventsSnap.docs.length + groupsSnap.docs.length;
    eventsNum = eventsSnap.docs.length;
    groupsNum = groupsSnap.docs.length;
    onlineUsers = onlineUsersSnap.docs.length;
    setState(() {});
  }

  int treasure = 0;
  getTreasure() async {
    String token = '';
    // await RelysiaManager.authUser(email, password).then(
    //   (res) async => {
    //     if (res['data'] != null)
    //       {
    //         if (res['statusCode'] == 200)
    //           {
    //             token = res['data']['token'],
    //           }
    //         else if (res['statusCode'] == 400 &&
    //             res['data']['msg'] == 'INVALID_EMAIL')
    //           {
    //             await RelysiaManager.authUser(email, password).then(
    //               (resData) => {
    //                 if (resData['data'] != null)
    //                   {
    //                     if (resData['statusCode'] == 200)
    //                       {
    //                         token = resData['data']['token'],
    //                       }
    //                     else
    //                       {Helper.showToast(resData['data']['msg'])}
    //                   }
    //                 else
    //                   {
    //                     Helper.showToast(resData['data']['msg']),
    //                   }
    //               },
    //             )
    //           }
    //       }
    //     else
    //       {
    //         Helper.showToast(res['data']['msg']),
    //       }
    //   },
    // );
  }
}
