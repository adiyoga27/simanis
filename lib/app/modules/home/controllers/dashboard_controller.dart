import 'dart:async';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/modules/home/views/widgets/appbar.dart';

class DashboardController extends GetxController {
  RxDouble headerHeight = 370.0.obs;
  RxDouble appbarOpacity = 1.0.obs;
  double height = 370;
  RxBool isLoading = true.obs;
  
  void onScroll(Scroller scroll) async {
    double pixels = scroll.pixels;

    if (pixels >= 0) {
      headerHeight.value = (height - pixels.abs()).clamp(10, height + 50);
    } else {
      headerHeight.value = height + pixels.abs();
    }

    if (pixels < 0) {
      appbarOpacity.value = scroll.opacity(30, ScrollOpacity.bottom10);
    } else {
      appbarOpacity.value = scroll.opacity(50, ScrollOpacity.top10);
    }
  }

  Future onAppInit() async {
    isLoading.value = true;
    // Toasts.show('Loading data...');
      Timer(2.s, () {
        Toasts.dismiss();
      });
    // if selected client is empty, show dialog
   
    isLoading.value = false;
      update();

  }

@override
  void onInit() {
    super.onInit();
    onAppInit();
    // isLoading.value = false;

  }


}
