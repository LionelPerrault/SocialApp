// ignore: file_names

import 'package:flutter/foundation.dart';

class ChatModel {
  late var chatInfo = {};
  late List users = [];
  late String chatId = '';
  late String lastData = '';
  late String avatar = '';
  ChatModel.fromJSON(Map<String, dynamic> json) {
    try {
      chatInfo = json;
      users = json['users'];
      lastData = json['lastData'];
    } catch (e) {
      if (kDebugMode) {
        print("error occurs =============== {$e}");
      }
    }
  }

  Map<String, Object?> toMap() {
    return {'chatInfo': chatInfo, 'users': users};
  }
}
