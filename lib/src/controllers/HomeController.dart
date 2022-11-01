import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/tokenlogin.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class HomeController extends ControllerMVC {
    factory HomeController([StateMVC? state]) =>
        _this ??= HomeController._(state);
    HomeController._(StateMVC? state)
        : super(state);
          
    static HomeController? _this;
}
            