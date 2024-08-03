import 'package:get/get.dart';

import '../controllers/physical_training_controller.dart';

class PhysicalTrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhysicalTrainingController>(
      () => PhysicalTrainingController(),
    );
  }
}
