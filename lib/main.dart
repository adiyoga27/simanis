import 'package:fetchly/models/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fetchly/fetchly.dart' as f;

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/theme/theme.dart';
import 'package:simanis/app/core/utils/fetchly_request_handler.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/firebase_options.dart';
import 'app/data/services/storage/storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
      );
  await AppConfig.init();

  // check if user is logged in
  String? token = storage.read('token');

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
      debugShowCheckedModeBanner: false,
      title: "Simanis",
      defaultTransition: Transition.cupertino,
      theme: appTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: LazyUi.builder,
    ),
  );
}
