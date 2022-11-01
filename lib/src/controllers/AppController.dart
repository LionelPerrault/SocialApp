
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tokenlogin.dart';
class AppController extends ControllerMVC {
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;
  
  get SharedPreferences => null;

  @override
  Future<bool> initAsync() async {
    await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
    );
    //
    
   
    //Stream<QuerySnapshot<TokenLogin>> data = await authdata.where('email', isEqualTo:sampleMail).snapshots();
    //data.forEach((element) {
    //  print(element);
    //});


    /*
    await Firestore.instance.collection("products").add({
    'productName': _productName,
    'productPrice': _productPrice,
    'imageUrl': _imageUrl,
    'isFavourite': _isFavourite,
    });
    */
    return true;
  }
  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }
}