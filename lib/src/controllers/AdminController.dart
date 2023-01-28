import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';

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
