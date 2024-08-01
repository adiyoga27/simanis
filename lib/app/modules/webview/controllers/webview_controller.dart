import 'package:get/get.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';

class WebviewController extends GetxController {
  RxBool isLoading = true.obs;
  final HomeController homeController = Get.find<HomeController>();
  final count = 0.obs;
 
}
