import 'package:get/get.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<WebViewController>(
      () => WebViewController(),
    );
       Get.lazyPut<HomeController>(
      () => HomeController(),
    );
        Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}
