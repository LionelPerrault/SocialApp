class TokenLogin {
  late String email = '';
  late String about = '';
  late String birthD = '';
  late String birthY = '';
  late String birthM = '';
  late String u_class = '';
  late String country = '';
  late String relysiaEmail = '';
  late String firstName = '';
  late String lastName = '';
  late String password = '';
  late String paymail = '';
  late String walletAddress = '';
  late String documentId = '';
  late String relysiaPassword = '';
  late String userName = '';
  late String userAvatar = '';
  late bool isStarted = false;
  late var userInfo = {};
  TokenLogin();

  TokenLogin.fromJSON(Map<String, dynamic> json) {
    try {
      email = json['email'] as String;
      firstName = json['firstName'] as String;
      lastName = json['lastName'] as String;
      userName = json['userName'] as String;
      relysiaEmail = json['relysiaEmail'] as String;
      relysiaPassword = json['relysiaPassword'] as String;
      paymail = json['paymail'] as String;
      walletAddress = json['walletAddress'] as String;
      isStarted = json['isStarted'] as bool;
      userAvatar = json['avatar'] as String;
      userInfo = json;
    } catch (e) {}
  }

  Map<String, Object?> toMap() {
    return {
      'email': email,
      'userInfo': userInfo,
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
