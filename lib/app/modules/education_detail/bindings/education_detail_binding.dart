import 'package:get/get.dart';

import '../controllers/education_detail_controller.dart';

class EducationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationDetailController>(
      () => EducationDetailController(),
    );
  }
}
