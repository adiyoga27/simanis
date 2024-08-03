import 'package:get/get.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';

import '../controllers/initial_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitialController>(() => InitialController(),);
    Get.lazyPut<DashboardController>(() => DashboardController(),);
  }
}
