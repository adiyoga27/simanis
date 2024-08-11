import 'package:get/get.dart';

import '../controllers/tnt_controller.dart';

class TntBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TntController>(
      () => TntController(),
    );
  }
}
