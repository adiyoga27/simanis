import 'package:get/get.dart';

import '../controllers/app_intro_controller.dart';

class AppIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppIntroController>(
      () => AppIntroController(),
    );
  }
}
