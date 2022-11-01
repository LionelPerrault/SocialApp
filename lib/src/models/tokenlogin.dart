
class TokenLogin {
  late String email = '';
  late String password = '';
  late String paymail = '';
  late String address = '';
  late String documentId = '';
  TokenLogin({
    required this.email,
    required this.password,
    required this.paymail,
    required this.address,
    required this.documentId,
  });

  TokenLogin.fromJSON(Map<String, dynamic> json) {
    try {
      email = json['email'] as String;
      password = json['password'] as String;
      paymail = json['paymail'] as String;
      address = json['address']  as String;
    } catch (e) {
    }
  }

  Map<String, Object?> toMap() {
    return {
      'email':email,
      'password':password,
      'address': address,
      'paymail': paymail
    };
  }
}
