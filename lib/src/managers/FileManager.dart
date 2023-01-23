import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';
import 'package:path/path.dart' as PPath;
import 'dart:io' show File, Platform;

class FileController extends ControllerMVC {
  factory FileController([StateMVC? state]) =>
      _this ??= FileController._(state);
  FileController._(StateMVC? state)
      : progress = 0,
        super(state);
  static FileController? _this;
  double progress;
  get SharedPreferences => null;
  static var userCon = UserController();
  static var downloadUrl;
  @override
  Future<bool> initAsync() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  Future<XFile> chooseImage() async {
    final _imagePicker = ImagePicker();
    XFile? pickedFile;
    if (kIsWeb) {
      pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      //Check Permissions
      // await Permission.photos.request();
      // var permissionStatus = await Permission.photos.status;

      //if (permissionStatus.isGranted) {
      pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      //} else {
      //  print('Permission not granted. Try Again with permission access');
      //}
    }
    return pickedFile!;
  }

  uploadFile(XFile? pickedFile) async {
    final _firebaseStorage = FirebaseStorage.instance;
    var uploadTask;
    Reference _reference;
    try {
      if (kIsWeb) {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        var file = File(pickedFile!.path);
        //write a code for android or ios
        _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = _reference.putFile(file);
      }
      uploadTask.whenComplete(() async {
        var downloadUrl = await _reference.getDownloadURL();
        userCon.userAvatar = downloadUrl;
        userCon.setState(() {});
        userCon.changeAvatar();
        //await _reference.getDownloadURL().then((value) {
        //  uploadedPhotoUrl = value;
        //});
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            setState(() {});
            print("Upload is $progress% complete.");

            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            print("Upload is completed");
            // Handle successful uploads on complete
            // ...
            //  var downloadUrl = await _reference.getDownloadURL();
            break;
        }
      });
    } catch (e) {
      // print("Exception $e");
    }
  }

  Future<Map> uploadImage({callBack}) async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile);
    return {'success': true, 'url': downloadUrl};
  }
}
