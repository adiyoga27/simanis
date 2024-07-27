import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:lazyui/lazyui.dart' hide MultipartFile;
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/data/models/user_model.dart';
import 'package:simanis/app/data/repository/storage/app_guide_storage.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:simanis/app/widgets/forms/forms.dart';

import '../../../data/services/api/api.dart';
class AccountController extends GetxController {
 AccountApi api = AccountApi();

  UserModel user = UserModel();

  Future getProfile() async {
    try {
      ResHandler res = await api.getProfile();

      if (res.status) {
        user = UserModel.fromJson(res.data);
        auth = user;

        storage.write('user_details', res.data);
        storage.write('user', res.data);
      } else {
        Toasts.show(res.message);
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  /* ---------------------------------------------------------
  | Change Password
  | --------------------------------------------- */

  Map<String, TextEditingController> formsPassword = Forms.create(['old_pass', 'new_pass', 'confirm_pass']);
  RxBool obsecure = true.obs;

  Future changePassword() async {
    try {
      Map<String, dynamic> map = formsPassword.toMap();
      String newPass = map['new_pass'], confirmPass = map['confirm_pass'];

      // Minimal 6 karakter
      if (newPass.length < 6) {
        Toasts.show('Password minimal 6 karakter.');
        return;
      }

      // (?=.*[a-z]) -> check if string contains lowercase
      // (?=.*[A-Z]) -> check if string contains uppercase
      // (?=.*[0-9]) -> check if string contains number
      // (?=.*[-+_!@#$%^&*.,?]) -> check if string contains special character
      bool isValid = newPass.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).+$', caseSensitive: true));

      if (!isValid) {
        return Toasts.show('Password harus mengandung huruf kapital, huruf kecil, dan angka.');
      }

      // Password confirmation
      if (confirmPass != newPass) {
        return Toasts.show('Konfirmasi password tidak sama.');
      }

      // Submit
      Toasts.overlay('Mengubah password...');
      final auth = await Auth.user();

      map['username'] = auth.username;
      map['group'] = Values.group;

      ResHandler res = await api.changePassword(map);
      Toasts.dismiss();

      if (!res.status) {
        return Toasts.show(res.message);
      }

      Toasts.show('Password berhasil diperbarui.');
      Get.back();

      // go to login page
      await Storage.remove(only: ['token', '_vmoney_pin_applied']);

      Get.delete<HomeController>();

      // back to login page
      Get.offAndToNamed(Routes.LOGIN);
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  
  /* ---------------------------------------------------------
  | Reset App Trainer Cache
  | --------------------------------------------- */

  Future resetAppTrainerCache() async {
    try {
      Toasts.overlay('Mereset cache...');

      List<ATType> except = [ATType.intro];

      await Future.forEach(ATType.values, (e) async {
        if (!except.contains(e)) await AppTutor.remove(e);
      });

      Toasts.show('Cache app trainer berhasil direset.');
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      Toasts.dismiss();
    }
  }
}
