import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/data/services/storage/storage.dart';

import '../../../data/services/api/api.dart';

class AccountDetailController extends GetxController {
  AccountApi api = AccountApi();
  RxBool isLoading = true.obs;
  ProfileModel profile = ProfileModel();

  Map<String, dynamic> account = {};

  Future getProfile() async {
    isLoading(true);

    try {
          String? token = storage.read('token');
      ResHandler res = await api.getProfile();
      profile = ProfileModel.fromJson(res.data);

      // update image in auth storage
      Map<String, dynamic> userMap = auth.toJson();
      // userMap['image'] = profile.avatar;
      await storage.write('profile', profile);

      // trigger user photo to update
      // Get.find<HomeController>().update(['appbar', 'profile']);

      // await checkAccountVerified();
    } catch (e, s) {
      Errors.check(e, s);
    }

    isLoading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  /* ---------------------------------------------------------
  | Verify Account
  | --------------------------------------------- */
  TextEditingController email = TextEditingController();
  File? file;
  RxBool scale = false.obs;

  final formsWa = LzForm.make(['calling_code', 'wa']);
  Option? selectedCallingCode;
  List<Option> callingCodes = [];

  Future changePhoto(File file) async {
    try {
      final auth = await Auth.user();
      String username = auth.username!;

      Toasts.overlay('Loading...');

      String base64 = await Utils.fileToBase64(file);
      Map<String, dynamic> data = {'picture': base64, 'name': username};
      ResHandler res = await api.changePhoto(data, username);
      Toasts.dismiss();

      if (!res.status) {
        return Toasts.show(res.message);
      }

      Toasts.show(res.message ?? 'Berhasil mengubah foto profil');
      getProfile();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}
