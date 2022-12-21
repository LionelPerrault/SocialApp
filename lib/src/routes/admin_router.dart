import 'package:shnatter/src/views/admin/admin_panel/pages/adminbodypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/currencies.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/design.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/languages.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/managePrice.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsAccountpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsAnalyticspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsChatpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsEmailpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLimitspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLivepanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsNotificationpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsPaymentpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsRegistrationpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSecuritypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsUploadpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsPostpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSMSpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSecuritypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSystempanel.dart';

import '../views/admin/admin_panel/pages/settingsSystempanel.dart';

class AdminRouter {
  AdminRouter(String settingPage);
  static adminRouter(settingPage) {
    switch (settingPage) {
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
      case '/settings/registration':
        return AdminSettingsRegistration();
      case '/settings/account':
        return AdminSettingsAccount();
      case '/settings/notification':
        return AdminSettingsNotification();
      case '/settings/upload':
        return AdminSettingsUpload();
      case '/settings/payments':
        return AdminSettingsPayment();
      case '/settings/posts':
        return AdminSettingsPosts();
      case '/settings/email':
        return AdminSettingsEmail();
      case '/settings/sms':
        return AdminSettingsSMS();
      case '/manage-prices':
        return AdminManagePrice();
      case '/design':
        return AdminDesign();
      case '/currencies':
        return AdminCurrencies();
      case '/languages':
        return AdminLanguages();
    }
  }
}
