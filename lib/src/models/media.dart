class Media {
  String id = '';
  String name = '';
  String url = '';
  String thumb = '';
  String icon = '';
  String size = '';

  Media({String? id, required String url, String? thumb, String? icon}) {
    this.id = id ?? "";
    this.url = url;
    this.thumb = thumb ?? "";
    this.icon = icon ?? "";
  }

  Media.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      url = jsonMap['url'];
      thumb = jsonMap['thumb'];
      icon = jsonMap['icon'];
      size = jsonMap['formated_size'];
    } catch (e) {}
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return toMap().toString();
  }
}
