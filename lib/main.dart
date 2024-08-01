import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/theme/theme.dart';
import 'app/data/services/storage/storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await AppConfig.init();

  // check if user is logged in
  String? token = storage.read('token');
  bool isLogged = (token != null);
  runApp(
    GetMaterialApp(
      title: "Simanis",
      theme: appTheme,
      initialRoute: isLogged ? Routes.HOME : AppPages.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return LazyUi.builder(context, child);
      },
    ),
  );
}
