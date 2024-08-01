import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/routes/app_pages.dart';

class AppIntroController extends GetxController {
  CarouselController carouselController = CarouselController();
  RxInt slide = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     bool hadIntro = storage.read('guide_app_intro') ?? false;

      if (!hadIntro) {
        Get.offAllNamed(Routes.HOME)?.then((value) => storage.write('guide_app_intro', true));
      }
  }
}
