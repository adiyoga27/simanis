import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

class BloodSugarController extends GetxController {
  final forms = LzForm.make(['data']);

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onSubmitGDP() {}
  void onSubmitGDS() {}
  void increment() => count.value++;
}
