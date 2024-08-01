import 'package:fetchly/models/config.dart';
import 'package:flutter/material.dart';
import 'package:fetchly/fetchly.dart' as f;

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/theme/theme.dart';
import 'package:simanis/app/core/utils/fetchly_request_handler.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'app/data/services/storage/storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await AppConfig.init();

  // check if user is logged in
  String? token = storage.read('token');
  bool isLogged = (token != null);

  f.Fetchly.init(
      baseUrl: 'https://simanis.codingaja.my.id/api/',
      onRequest: RequestHandler.onRequest,
      config: FetchlyConfig(printLimit: 5000));

  // set token for api
  if (token != null) {
    dio.options.headers['authorization'] = 'Bearer $token';
    // dio2.options.headers['authorization'] = 'Bearer $token';

    // set juga di fetchly
    f.dio.setToken(token);
  }

  LzConfirm.config(confirm: 'Ya, Hapus', cancel: 'Batal');


  runApp(
    GetMaterialApp(
      title: "Simanis",
      theme: appTheme,
      initialRoute: isLogged ? Routes.APPINTRO : AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return LazyUi.builder(context, child);
      },
    ),
  );
}
