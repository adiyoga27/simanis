import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:fetchly/fetchly.dart' as f;
import 'package:fetchly/models/config.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetchly_request_handler.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/modules/farmakologi/views/ring.dart';
import 'package:simanis/app/routes/app_pages.dart';


class InitialController extends GetxController {
RxBool isLogged = false.obs;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void onInit() {
    super.onInit();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);

    // check existing token
    String? token = storage.read('token');
    logg(token);
    f.Fetchly.init(
      baseUrl: 'https://simanis.codingaja.com/api/',
      onRequest: RequestHandler.onRequest,
      config: FetchlyConfig(printLimit: 5000));
    if (token != null) {
      f.Fetchly.setToken(token);
      dio.options.headers['authorization'] = 'Bearer $token';
          dio.setToken(token);
          f.dio.options.headers['Authorization'] = 'Bearer $token';
          f.dio.setToken(token);
      isLogged.value = true;
    }
  }
    @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  
   void checkRoutes() {
      // check existing token
    String? token = storage.read('token');

    if (token != null) {
      f.Fetchly.setToken(token);
      Get.offAllNamed(Routes.HOME);
    }else{
      Get.toNamed(Routes.LOGIN);
    }
    return;
  }
}

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Get.to(ExampleAlarmRingScreen(
      alarmSettings: alarmSettings,
    ));
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
