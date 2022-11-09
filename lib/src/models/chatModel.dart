class ChatModel {
  late String email = '';
  late String relysiaEmail = '';
  late String firstName = '';
  late String lastName = '';
  late String password = '';
  late String paymail = '';
  late String walletAddress = '';
  late String documentId = '';
  late String relysiaPassword = '';
  late String userName = '';
  late bool isStarted = false;
  ChatModel();

  ChatModel.fromJSON(Map<String, dynamic> json) {
    try {
      email = json['email'] as String;
      firstName = json['firstName'] as String;
      lastName = json['lastName'] as String;
      userName = json['userName'] as String;
      relysiaEmail = json['relysiaEmail'] as String;
      relysiaPassword = json['relysiaPassword'] as String;
      paymail = json['paymail'] as String;
      walletAddress = json['walletAddress'] as String;
      password = json['password'] as String;
      isStarted = json['isStarted'] as bool;
    } catch (e) {}
  }

  Map<String, Object?> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'password': password,
      'relysiaEmail': relysiaEmail,
      'relysiaPassword': relysiaPassword,
      'walletAddress': walletAddress,
      'paymail': paymail,
      'isStarted': isStarted
    };
  }
}
