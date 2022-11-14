class Emoticon {
  late String emoticon = '';
  Emoticon();

  Emoticon.fromJSON(Map<String, dynamic> json) {
    try {
      emoticon = json['emoticon'] as String;
    } catch (e) {}
  }

  Map<String, Object?> toMap() {
    return {
      'email': emoticon,
    };
  }
}
