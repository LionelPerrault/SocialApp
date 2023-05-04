import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp(key: Key('Shnatter')));
}
