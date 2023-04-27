import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import '../../firebase_options.dart';
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
    final imagePicker = ImagePicker();
    XFile? pickedFile;
    if (kIsWeb) {
      pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      //Check Permissions
      // await Permission.photos.request();
      // var permissionStatus = await Permission.photos.status;

      pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
    }
    return pickedFile!;
  }

  uploadFile(XFile? pickedFile) async {
    final firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask;
    Reference reference;
    try {
      if (kIsWeb) {
        Uint8List bytes = await pickedFile!.readAsBytes();
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        var file = File(pickedFile!.path);
        //write a code for android or ios
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putFile(file);
      }
      uploadTask.whenComplete(() async {
        var downloadUrl = await reference.getDownloadURL();
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

            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
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
