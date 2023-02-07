// ignore_for_file: file_names

import 'package:mvc_pattern/mvc_pattern.dart';

class AdminController extends ControllerMVC {
  factory AdminController([StateMVC? state]) =>
      _this ??= AdminController._(state);
  AdminController._(StateMVC? state)
      : eventSubRoute = '',
        super(state);
  static AdminController? _this;

  //variable
  List events = [];

  //sub route
  String eventSubRoute;

  @override
  Future<bool> initAsync() async {
    return true;
  }
}
