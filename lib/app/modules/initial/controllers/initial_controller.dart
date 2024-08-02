import 'dart:async';

import 'package:fetchly/fetchly.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';

class InitialController extends GetxController {
RxBool isLogged = false.obs;

  @override
  void onInit() {
    super.onInit();

    // check existing token
    String? token = storage.read('token');

    if (token != null) {
      Fetchly.setToken(token);
      isLogged.value = true;
    }
  }
   void checkRoutes() {
      // check existing token
    String? token = storage.read('token');

    if (token != null) {
      Fetchly.setToken(token);
      Get.offAllNamed(Routes.HOME);
    }else{
      Get.toNamed(Routes.LOGIN);
    }
    return;
  }
}




mixin class AppState {
  void setAuth(bool value) {
    final app = Get.find<InitialController>();
    app.isLogged.value = value;

    if (!value) {
      storage.remove('token');
      storage.remove('user');
    }
  }

  static logout() async {
    final app = Get.find<InitialController>();
    // final dashboard = Get.find<DashboardController>();

   storage.remove('token');
      storage.remove('user');

    // unsubscribe
    // FbMessaging.unsubscribeTopic(
    //     dashboard.clients.map((e) => e.cloudId.toString()).toList());
    // FbMessaging.unsubscribeTopic([Auth.user.id, Auth.user.email, Auth.user.username]);

    app.isLogged.value = false;
  }
}
