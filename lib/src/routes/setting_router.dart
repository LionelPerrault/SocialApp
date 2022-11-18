
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
import 'package:shnatter/src/views/setting/panel/pages/account_page.dart';


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
      case 'design' :
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
