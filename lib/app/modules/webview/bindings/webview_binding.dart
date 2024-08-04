import 'package:get/get.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';

import '../controllers/webview_controller.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(
      () => WebviewController(),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
