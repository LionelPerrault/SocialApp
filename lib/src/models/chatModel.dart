// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late var chatInfo = {};
  late List users = [];
  late String chatId= '';
  ChatModel.fromJSON(Map<String, dynamic> json) {
    try {
      chatInfo = json;
      users = json['users'];
      chatId = json['id'];
    } catch (e) {
      print("error occurs =============== {$e}");
    }
  }

  Map<String, Object?> toMap() {
    return {'chatInfo': chatInfo, 'users': users};
  }
}
