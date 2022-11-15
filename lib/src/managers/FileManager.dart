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

class FileManager {
  get SharedPreferences => null;
  static var userCon = UserController();
  static var progress;
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

  static Future<XFile> chooseImage() async {
    final _imagePicker = ImagePicker();
    XFile? pickedFile;
    if (kIsWeb) {
      pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
      } else {
        print('Permission not granted. Try Again with permission access');
      }
    }
    return pickedFile!;
  }

  static uploadFile(XFile? pickedFile) async {
    final _firebaseStorage = FirebaseStorage.instance;
    bool success = false;
    if (kIsWeb) {
      try {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        Reference _reference = await _firebaseStorage
            .ref()
            .child('chat-assets/${PPath.basename(pickedFile!.path)}');
        final uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        await uploadTask.whenComplete(() async {
          downloadUrl = await _reference.getDownloadURL();
          userCon.userAvatar = downloadUrl;
          success = true;
          //await _reference.getDownloadURL().then((value) {
          //  uploadedPhotoUrl = value;
          //});
        });
        // ignore: await_only_futures
        await uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
    } else {
      var file = File(pickedFile!.path);
      //write a code for android or ios
      Reference _reference = await _firebaseStorage
          .ref()
          .child('chat-assets/${PPath.basename(pickedFile!.path)}');
      _reference.putFile(file).whenComplete(() async {
        print('value');
        var downloadUrl = await _reference.getDownloadURL();
        await _reference.getDownloadURL().then((value) {
          // userCon.userAvatar = value;
          // userCon.setState(() {});
          // print(value);
        });
      });
    }
    return success;
  }

  static Future<Map> uploadImage() async {
    XFile? pickedFile = await chooseImage();
    var s = await uploadFile(pickedFile);
    return {'success': s, 'url': downloadUrl};
  }
}
