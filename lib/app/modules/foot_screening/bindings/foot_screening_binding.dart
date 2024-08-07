import 'package:get/get.dart';

import '../controllers/foot_screening_controller.dart';

class FootScreeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FootScreeningController>(
      () => FootScreeningController(),
    );
  }
}
