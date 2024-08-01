import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simanis/app/modules/home/views/dashboard_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashboardView(),
    );
  }
}
