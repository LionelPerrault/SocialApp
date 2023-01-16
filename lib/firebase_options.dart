// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBx_Q9urZ3llnD-hkv74g1XAQWKX9uJmn4',
    appId: '1:444281700591:web:ccfe53aa54bf21fd379b1a',
    messagingSenderId: '444281700591',
    projectId: 'shnatter-a69cd',
    authDomain: 'shnatter-a69cd.firebaseapp.com',
    databaseURL: 'https://shnatter-a69cd-default-rtdb.firebaseio.com',
    storageBucket: 'shnatter-a69cd.appspot.com',
    measurementId: 'G-XGX27JVMQK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-RqSJmu411enQssXc1vlyZyh-FVyJYUs',
    appId: '1:444281700591:android:a55a5c768f8abcd6379b1a',
    messagingSenderId: '444281700591',
    projectId: 'shnatter-a69cd',
    databaseURL: 'https://shnatter-a69cd-default-rtdb.firebaseio.com',
    storageBucket: 'shnatter-a69cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1WUKwEBIyE9yHdfHAcGl2RE93CxIuo3o',
    appId: '1:444281700591:ios:81f6abe04b42f719379b1a',
    messagingSenderId: '444281700591',
    projectId: 'shnatter-a69cd',
    databaseURL: 'https://shnatter-a69cd-default-rtdb.firebaseio.com',
    storageBucket: 'shnatter-a69cd.appspot.com',
    iosClientId: '444281700591-1p7f4j0taft8hkg62mjcv5em4aeegjce.apps.googleusercontent.com',
    iosBundleId: 'com.example.shnatter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1WUKwEBIyE9yHdfHAcGl2RE93CxIuo3o',
    appId: '1:444281700591:ios:81f6abe04b42f719379b1a',
    messagingSenderId: '444281700591',
    projectId: 'shnatter-a69cd',
    databaseURL: 'https://shnatter-a69cd-default-rtdb.firebaseio.com',
    storageBucket: 'shnatter-a69cd.appspot.com',
    iosClientId: '444281700591-1p7f4j0taft8hkg62mjcv5em4aeegjce.apps.googleusercontent.com',
    iosBundleId: 'com.example.shnatter',
  );
}
