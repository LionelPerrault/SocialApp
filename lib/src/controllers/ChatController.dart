import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';
import '../models/chatModel.dart';
import '../models/userModel.dart';

class ChatController extends ControllerMVC {
  factory ChatController() => _this ??= ChatController._();
  ChatController._();
  static ChatController? _this;
  var chatBoxs = [];
  var type = 'text';
  var chatUserList = [];
  var chattingUser = '';
  var isMessageTap = 'all-list';
  var docId = '';
  var newRFirstName = '';
  var newRLastName = '';
  var chatId = '';
  var avatar = '';
  bool isShowEmoticon = false;
  @override
  Future<bool> initAsync() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  Future<bool> sendMessage(newOrNot, data) async {
    var newChat = false;
    bool success = false;
    if (chattingUser == '' || data == '') {
      success = false;
    }
    Response res = await get(
        Uri.http('worldtimeapi.org', '/api/timezone/America/Los_Angeles'));
    var d = jsonDecode(res.body);
    if (newOrNot == 'new') {
      await FirebaseFirestore.instance.collection(Helper.message).add({
        'users': [UserManager.userInfo['userName'], chattingUser],
        UserManager.userInfo['userName']: {
          'name':
              '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
          'avatar': UserManager.userInfo['avatar'] ?? ''
        },
        chattingUser: {
          'name': '$newRFirstName $newRLastName',
          'avatar': avatar
        },
        'lastData': data
      }).then((value) async {
        docId = value.id;
        success = true;
        setState(() {});
        await FirebaseFirestore.instance
            .collection(Helper.message)
            .doc(value.id)
            .collection('content')
            .add({
          'type': type,
          'sender': UserManager.userInfo['userName'],
          'receiver': chattingUser,
          'data': data,
          'timeStamp': DateTime.parse(d['datetime'])
        });
      });
    } else {
      success = true;
      FirebaseFirestore.instance
          .collection(Helper.message)
          .doc(docId)
          .update({'lastData': data});
      FirebaseFirestore.instance
          .collection(Helper.message)
          .doc(docId)
          .collection('content')
          .add({
        'type': type,
        'sender': UserManager.userInfo['userName'],
        'receiver': chattingUser,
        'data': data,
        'timeStamp': DateTime.parse(d['datetime'])
      }).then((value) => {});
    }
    return success;
  }
}
