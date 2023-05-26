import 'package:flutter/cupertino.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'src/app.dart';

void main() async {
  Helper.environment = Environment.dev;
  runApp(const MyApp(key: Key('Shnatter')));
}
