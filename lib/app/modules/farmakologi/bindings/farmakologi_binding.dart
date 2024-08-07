import 'package:get/get.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmakologiController>(
      () => FarmakologiController(),
    );
  }
}
