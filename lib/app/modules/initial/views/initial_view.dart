import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simanis/app/modules/home/views/home_view.dart';
import 'package:simanis/app/modules/login/views/login_view.dart';

import '../controllers/initial_controller.dart';

class InitialView extends GetView<InitialController> {
  const InitialView({Key? key}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    // final ctrl = Get.find<InitialController>();
    //   ctrl.checkRoutes();
    return Scaffold(body: Obx(() {
      if (controller.isLogged.value) {
        return const HomeView();
      }
      return const LoginView();
    }));
  }
}
