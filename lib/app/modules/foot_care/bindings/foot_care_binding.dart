import 'package:get/get.dart';

import '../controllers/foot_care_controller.dart';

class FootCareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FootCareController>(
      () => FootCareController(),
    );
  }
}
