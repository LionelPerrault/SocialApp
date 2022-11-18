
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/setting/panel/pages/delete.dart';
import 'package:shnatter/src/views/setting/panel/pages/information.dart';
import 'package:shnatter/src/views/setting/panel/pages/notifications.dart';
import 'package:shnatter/src/views/setting/panel/pages/privacy.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_basic_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_design_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_education_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_location_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_social_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/profile_work_page.dart';
import 'package:shnatter/src/views/setting/panel/pages/security_password.dart';
import 'package:shnatter/src/views/setting/panel/pages/security_sessions.dart';
import 'package:shnatter/src/views/setting/panel/pages/shnatter_token.dart';
import 'package:shnatter/src/views/setting/panel/pages/verification.dart';
import 'package:shnatter/src/views/setting/panel/settng_left_panel.dart';
import 'package:shnatter/src/views/setting/panel/pages/account_page.dart';

import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import '../../widget/mprimary_button.dart';
import '../../widget/list_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../box/notification.dart';

class SettingRouter{
  SettingRouter(String settingPage);
  static settingRouter(settingPage) {
    switch(settingPage){
      case 'account_page': 
        return SettingAccountScreen();
      case 'basic':
        return SettingBasicScreen();
      case 'work':
        return SettingWorkScreen();
      case 'location' :
         return SettingLocationScreen();
      case 'education' :
         return SettingEducationScreen();
      case 'social' :
         return SettingSocialScreen();
      case 'Design' :
         return SettingDesignScreen();
      case 'security_password': 
         return SettingSecurityPasswordScreen();
      case 'security_session': 
         return SettingSecuritySessScreen();
      case 'privacy': 
        return  SettingPrivacyScreen();
      case 'notification': 
         return SettingNotificationScreen();
      case 'shnatter_token': 
         return SettingShnatterTokenScreen();
      case 'verification': 
         return SettingVerificationScreen();
      case 'information': 
        return  SettingInfoScreen();
      case 'delete':
       return SettingDeleteScreen();
    } 
  }
}
