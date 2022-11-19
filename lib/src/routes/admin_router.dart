
import 'package:shnatter/src/views/admin/admin_panel/pages/adminbodypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsAnalyticspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsChatpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsEmailpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLimitspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLivepanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsPostpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSecuritypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSystempanel.dart';

import '../views/admin/admin_panel/pages/settingsSystempanel.dart';


class AdminRouter{
  AdminRouter(String settingPage);
  static adminRouter(settingPage) {
    switch(settingPage){
      case '': 
        return AdminMainPanel();
      case '/settings/analystics': 
        return AdminSettingsAnalytics();
      case '/settings/chat': 
        return AdminSettingsChat();
      case '/settings/limits': 
        return AdminSettingsLimits();
      case '/settings/live': 
        return AdminSettingsLive();
      case '/settings/system':
        return AdminSettingsSystem();
      case '/settings/security': 
        return AdminSettingsSecurity();
      case '/settings': 
        return AdminSettingsSystem();
      case '/settings/posts': 
        return AdminSettingsPosts();
      case '/settings/email': 
        return AdminSettingsEmail();

    } 
  }
}
