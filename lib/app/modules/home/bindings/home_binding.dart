import 'package:get/get.dart';

import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
