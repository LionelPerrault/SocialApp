// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';

class HomeController extends ControllerMVC {
  factory HomeController([StateMVC? state]) =>
      _this ??= HomeController._(state);
  HomeController._(StateMVC? state) : super(state);
  static HomeController? _this;

  var leaderBoard = [];
  @override
  Future<bool> initAsync() async {
    //

    return true;
  }
}
